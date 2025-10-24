defmodule MessagingService.ConversationsTest do
  use MessagingService.DataCase

  alias MessagingService.Messages.Conversation
  alias MessagingService.Conversations
  import MessagingService.Factory

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
end
