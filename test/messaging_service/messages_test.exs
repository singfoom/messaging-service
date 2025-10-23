defmodule MessagingService.MessagesTest do
  use MessagingService.DataCase

  alias MessagingService.Messages
  alias MessagingService.Messages.Message

  import MessagingService.Factory

  describe "messages" do
    @invalid_attrs %{timestamp: nil, type: nil, body: nil, to: nil, from: nil, attachments: nil}

    test "list_messages/0 returns all messages" do
      message = insert(:message)
      assert Messages.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = insert(:message)
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{
        timestamp: ~U[2025-10-22 20:11:00Z],
        type: "some type",
        body: "some body",
        to: "some to",
        from: "some from",
        attachments: []
      }

      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs)
      assert message.timestamp == ~U[2025-10-22 20:11:00Z]
      assert message.type == "some type"
      assert message.body == "some body"
      assert message.to == "some to"
      assert message.from == "some from"
      assert message.attachments == []
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = insert(:message)

      update_attrs = %{
        timestamp: ~U[2025-10-23 20:11:00Z],
        type: "some updated type",
        body: "some updated body",
        to: "some updated to",
        from: "some updated from",
        attachments: ["option1"]
      }

      assert {:ok, %Message{} = message} = Messages.update_message(message, update_attrs)
      assert message.timestamp == ~U[2025-10-23 20:11:00Z]
      assert message.type == "some updated type"
      assert message.body == "some updated body"
      assert message.to == "some updated to"
      assert message.from == "some updated from"
      assert message.attachments == ["option1"]
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = insert(:message)
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = insert(:message)
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = insert(:message)
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
