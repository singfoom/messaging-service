defmodule MessagingService.ConversationsTest do
  use MessagingService.DataCase

  alias MessagingService.Messages.Conversation
  alias MessagingService.Conversations
  import MessagingService.Factory

  describe "get_conversation/1" do
    test "it returns an existing book by id" do
      conversation = insert(:conversation)
      result = Conversations.get_conversation(conversation.id)
      assert is_struct(result, Conversation)
    end

    test "it returns nil for a non existent id" do
      assert is_nil(Conversations.get_conversation(234))
    end

    test "it returns associated messages" do
      conversation = insert(:conversation)
      insert(:sms_message, conversation: conversation)
      insert(:sms_message, conversation: conversation)
      result = Conversations.get_conversation(conversation.id)
      assert Ecto.assoc_loaded?(result.messages)
      assert length(result.messages) == 2
    end
  end

  describe "get_by_participants/1" do
    test "returns nil when no records can be found" do
      assert is_nil(Conversations.get_by_participants(["hello@foo.com", "foo@hello.com"]))
    end

    test "returns a conversation when the participants are found" do
      %{participants: participants} = insert(:conversation)

      %Conversation{participants: returned_participants} =
        conversation =
        Conversations.get_by_participants(participants)

      assert is_struct(conversation, Conversation)
      assert returned_participants == participants
    end
  end

  describe "find_or_create_conversation_with_message/1" do
    test "creates new conversation with participants if none exists" do
      message_params = %{
        to: "+12016661234",
        from: "+18045551234",
        type: "sms",
        body: "Hello! This is a test MMS message with attachment.",
        attachments: nil,
        timestamp: "2024-11-01T14:00:00Z"
      }

      assert is_nil(Conversations.get_by_participants(["+12016661234", "+18045551234"]))

      {:ok, conversation} = Conversations.find_or_create_conversation_with_message(message_params)

      assert !is_nil(Conversations.get_by_participants(["+12016661234", "+18045551234"]))

      result = Conversations.get_conversation(conversation.id)
      assert Ecto.assoc_loaded?(result.messages)
      assert length(result.messages) == 1
    end
  end

  test "it associates a new message with an appropriate existing conversation" do
    first_message_params = %{
      to: "+12016661234",
      from: "+18045551234",
      type: "sms",
      body: "Hello! This is a test MMS message.",
      attachments: nil,
      timestamp: "2024-11-01T14:00:00Z"
    }

    # reverse the to and from
    second_message_params = %{
      to: "+18045551234",
      from: "+12016661234",
      type: "sms",
      body: "Hello! This is a test MMS respone.",
      attachments: nil,
      timestamp: "2024-11-01T14:30:00Z"
    }

    assert is_nil(Conversations.get_by_participants(["+12016661234", "+18045551234"]))

    assert Repo.aggregate(Conversation, :count) == 0

    {:ok, conversation} =
      Conversations.find_or_create_conversation_with_message(first_message_params)

    assert !is_nil(Conversations.get_by_participants(["+12016661234", "+18045551234"]))

    assert Repo.aggregate(Conversation, :count) == 1

    {:ok, _message} =
      Conversations.find_or_create_conversation_with_message(second_message_params)

    result = Conversations.get_conversation(conversation.id)
    assert Ecto.assoc_loaded?(result.messages)
    assert length(result.messages) == 2
  end
end
