defmodule MessagingService.Messages.MessageTest do
  use MessagingService.DataCase

  alias MessagingService.Messages.Message

  describe "changeset/2" do
    test "valid changeset with sms fields" do
      changeset =
        Message.changeset(%Message{}, %{
          to: "+12016661234",
          from: "+18045551234",
          type: "sms",
          body: "Hello! This is a test MMS message with attachment.",
          attachments: ["https://example.com/image.jpg"],
          timestamp: "2024-11-01T14:00:00Z"
        })

      assert changeset.valid?
      assert changeset.changes.to == "+12016661234"
      assert changeset.changes.from == "+18045551234"
      assert changeset.changes.type == "sms"
      assert changeset.changes.body == "Hello! This is a test MMS message with attachment."
      assert changeset.changes.attachments == ["https://example.com/image.jpg"]
    end

    test "valid changeset with email fields" do
      changeset =
        Message.changeset(%Message{}, %{
          to: "user@usehatchapp.com",
          from: "contact@gmail.com",
          type: "email",
          body: "Hello! This is a test email message with <b>HTML</b> formatting.",
          attachments: ["https://example.com/image.jpg"],
          timestamp: "2024-11-01T14:00:00Z"
        })

      assert changeset.valid?
      assert changeset.changes.to == "user@usehatchapp.com"
      assert changeset.changes.from == "contact@gmail.com"
      assert changeset.changes.type == "email"

      assert changeset.changes.body ==
               "Hello! This is a test email message with <b>HTML</b> formatting."

      assert changeset.changes.attachments == ["https://example.com/image.jpg"]
    end

    test "valid changeset with nil attachments" do
      changeset =
        Message.changeset(%Message{}, %{
          to: "+12016661234",
          from: "+18045551234",
          type: "sms",
          body: "Hello! This is a test MMS message with attachment.",
          attachments: nil,
          timestamp: "2024-11-01T14:00:00Z"
        })

      assert changeset.valid?
      assert changeset.changes.to == "+12016661234"
      assert changeset.changes.from == "+18045551234"
      assert changeset.changes.type == "sms"
      assert changeset.changes.body == "Hello! This is a test MMS message with attachment."
    end

    test "invalid changeset without required fields" do
      changeset =
        Message.changeset(%Message{}, %{
          attachments: ["https://example.com/image.jpg"]
        })

      refute changeset.valid?
      assert changeset.changes == %{attachments: ["https://example.com/image.jpg"]}
    end

    test "ignores invalid fields" do
      changeset =
        Message.changeset(%Message{}, %{
          to: "+12016661234",
          from: "+18045551234",
          type: "sms",
          body: "Hello! This is a test MMS message with attachment.",
          attachments: nil,
          timestamp: "2024-11-01T14:00:00Z",
          invalid_field: "huh?"
        })

      assert changeset.valid?
      refute Map.has_key?(changeset.changes, :invalid_field)
    end
  end
end
