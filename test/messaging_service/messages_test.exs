defmodule MessagingService.MessagesTest do
  use MessagingService.DataCase

  alias MessagingService.Messages
  alias MessagingService.Messages.Message

  import MessagingService.Factory

  describe "messages" do
    @invalid_attrs %{timestamp: nil, type: nil, body: nil, to: nil, from: nil, attachments: nil}

    test "list_messages/0 returns all messages" do
      message = insert(:sms_message)
      assert Messages.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = insert(:sms_message)
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{
        timestamp: ~U[2025-10-22 20:11:00Z],
        type: "sms",
        body: "some body",
        to: "some to",
        from: "some from",
        attachments: []
      }

      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs)
      assert message.timestamp == ~U[2025-10-22 20:11:00Z]
      assert message.type == "sms"
      assert message.body == "some body"
      assert message.to == "some to"
      assert message.from == "some from"
      assert message.attachments == []
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "change_message/1 returns a message changeset" do
      message = insert(:sms_message)
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
