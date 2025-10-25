defmodule MessagingService.MessagesTest do
  use MessagingService.DataCase

  alias MessagingService.Messages
  alias MessagingService.Messages.Message

  import MessagingService.Factory

  describe "list_messages/0" do
    test "list_messages/0 returns all messages" do
      message = insert(:sms_message)
      assert Messages.list_messages() == [message]
    end
  end

  describe "get_message!/1" do
    test "get_message!/1 returns the message with given id" do
      message = insert(:sms_message)
      assert Messages.get_message!(message.id) == message
    end
  end

  describe "create_message/1" do
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
      invalid_attrs = %{
        timestamp: nil,
        type: nil,
        body: nil,
        to: nil,
        from: nil,
        attachments: nil
      }

      assert {:error, %Ecto.Changeset{}} = Messages.create_message(invalid_attrs)
    end
  end

  describe "change_message/1" do
    test "change_message/1 returns a message changeset" do
      message = insert(:sms_message)
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end

  describe "get_by_messaging_provider_id/1" do
    test "returns a given message with the messaging_provider_id" do
      message = insert(:sms_message, messaging_provider_id: "sm14223")
      assert Messages.get_by_messaging_provider_id("sm14223") == message
    end

    test "returns nil given a non existent messaging_provider_id" do
      assert is_nil(Messages.get_by_messaging_provider_id("sm98793"))
    end
  end
end
