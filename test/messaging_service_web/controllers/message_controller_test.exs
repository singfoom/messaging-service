defmodule MessagingServiceWeb.MessageControllerTest do
  use MessagingServiceWeb.ConnCase

  alias MessagingService.Conversations

  describe "send_sms/2" do
    test "creates new conversation and SMS message when participants don't have existing conversation",
         %{conn: conn} do
      params = %{
        "from" => "+15551234567",
        "to" => "+15559876543",
        "type" => "sms",
        "body" => "Hello, this is a test message",
        "attachments" => [],
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/messages/sms", params)

      assert json_response(conn, 201) == %{"message" => "Message created"}

      # Verify conversation was created
      conversation = Conversations.get_by_participants(["+15551234567", "+15559876543"])
      assert conversation != nil
      assert length(conversation.participants) == 2
      assert "+15551234567" in conversation.participants
      assert "+15559876543" in conversation.participants

      # Verify message was created
      conversation_with_messages = Conversations.get_conversation(conversation.id)
      assert length(conversation_with_messages.messages) == 1
      message = hd(conversation_with_messages.messages)
      assert message.from == "+15551234567"
      assert message.to == "+15559876543"
      assert message.type == "sms"
      assert message.body == "Hello, this is a test message"
    end

    test "adds SMS message to existing conversation when participants already have one", %{
      conn: conn
    } do
      # Create initial conversation with a message
      first_params = %{
        "from" => "+15551234567",
        "to" => "+15559876543",
        "type" => "sms",
        "body" => "First message",
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      post(conn, ~p"/api/messages/sms", first_params)

      # Send second message between same participants (reversed direction)
      second_params = %{
        "from" => "+15559876543",
        "to" => "+15551234567",
        "type" => "sms",
        "body" => "Reply message",
        "timestamp" => "2024-11-01T14:05:00Z"
      }

      conn = post(conn, ~p"/api/messages/sms", second_params)

      assert json_response(conn, 201) == %{"message" => "Message created"}

      # Verify still only one conversation exists
      conversation = Conversations.get_by_participants(["+15551234567", "+15559876543"])
      conversation_with_messages = Conversations.get_conversation(conversation.id)

      # Should have 2 messages now
      assert length(conversation_with_messages.messages) == 2
    end

    test "creates MMS message when type is mms", %{conn: conn} do
      params = %{
        "from" => "+15551234567",
        "to" => "+15559876543",
        "type" => "mms",
        "body" => "Check out this picture",
        "attachments" => ["https://example.com/image.jpg"],
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/messages/sms", params)

      assert json_response(conn, 201) == %{"message" => "Message created"}

      conversation = Conversations.get_by_participants(["+15551234567", "+15559876543"])
      conversation_with_messages = Conversations.get_conversation(conversation.id)
      message = hd(conversation_with_messages.messages)

      assert message.type == "mms"
      assert message.attachments == ["https://example.com/image.jpg"]
    end

    test "handles missing optional attachments field", %{conn: conn} do
      params = %{
        "from" => "+15551234567",
        "to" => "+15559876543",
        "type" => "sms",
        "body" => "No attachments",
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/messages/sms", params)

      assert json_response(conn, 201) == %{"message" => "Message created"}
    end

    test "returns 400 when to field is missing", %{conn: conn} do
      invalid_params = %{
        "from" => "+15551234567",
        "type" => "sms",
        "body" => "Test",
        "timestamp" => "2024-11-01T14:00:00Z"
        # Missing to
      }

      conn = post(conn, ~p"/api/messages/sms", invalid_params)

      assert json_response(conn, 400)["errors"]["detail"] =~ "Missing required fields"
      assert json_response(conn, 400)["errors"]["detail"] =~ "to"
    end

    test "returns 400 when from field is missing", %{conn: conn} do
      invalid_params = %{
        "to" => "+15559876543",
        "type" => "sms",
        "body" => "Test",
        "timestamp" => "2024-11-01T14:00:00Z"
        # Missing from
      }

      conn = post(conn, ~p"/api/messages/sms", invalid_params)

      assert json_response(conn, 400)["errors"]["detail"] =~ "Missing required fields"
      assert json_response(conn, 400)["errors"]["detail"] =~ "from"
    end

    test "returns 400 when both from and to are missing", %{conn: conn} do
      invalid_params = %{
        "type" => "sms",
        "body" => "Test",
        "timestamp" => "2024-11-01T14:00:00Z"
        # Missing from and to
      }

      conn = post(conn, ~p"/api/messages/sms", invalid_params)

      response = json_response(conn, 400)
      assert response["errors"]["detail"] =~ "Missing required fields"
      assert response["errors"]["detail"] =~ "from"
      assert response["errors"]["detail"] =~ "to"
    end

    test "returns 422 when timestamp is invalid", %{conn: conn} do
      params = %{
        "from" => "+15551234567",
        "to" => "+15559876543",
        "type" => "sms",
        "body" => "Test",
        "timestamp" => nil
      }

      conn = post(conn, ~p"/api/messages/sms", params)

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "returns 422 when message type is invalid", %{conn: conn} do
      params = %{
        "from" => "+15551234567",
        "to" => "+15559876543",
        "type" => "invalid_type",
        "body" => "Test",
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/messages/sms", params)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "send_email/2" do
    test "creates new conversation and email message when participants don't have existing conversation",
         %{conn: conn} do
      params = %{
        "from" => "user@test.com",
        "to" => "contact@example.com",
        "body" => "<html><body>Email body with <b>HTML</b></body></html>",
        "attachments" => [],
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/messages/email", params)

      assert json_response(conn, 201) == %{"message" => "Message created"}

      # Verify conversation was created
      conversation = Conversations.get_by_participants(["user@test.com", "contact@example.com"])
      assert conversation != nil

      # Verify message was created with type "email"
      conversation_with_messages = Conversations.get_conversation(conversation.id)
      message = hd(conversation_with_messages.messages)
      assert message.type == "email"
      assert message.from == "user@test.com"
      assert message.to == "contact@example.com"
    end

    test "adds email message to existing conversation", %{conn: conn} do
      # Create initial email
      first_params = %{
        "from" => "user@test.com",
        "to" => "contact@example.com",
        "body" => "First email",
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      post(conn, ~p"/api/messages/email", first_params)

      # Send reply
      second_params = %{
        "from" => "contact@example.com",
        "to" => "user@test.com",
        "body" => "Reply email",
        "timestamp" => "2024-11-01T14:05:00Z"
      }

      conn = post(conn, ~p"/api/messages/email", second_params)

      assert json_response(conn, 201) == %{"message" => "Message created"}

      # Verify both messages in same conversation
      conversation = Conversations.get_by_participants(["user@test.com", "contact@example.com"])
      conversation_with_messages = Conversations.get_conversation(conversation.id)
      assert length(conversation_with_messages.messages) == 2
    end

    test "handles email with attachments", %{conn: conn} do
      params = %{
        "from" => "user@test.com",
        "to" => "contact@example.com",
        "body" => "Email with attachments",
        "attachments" => [
          "https://example.com/document.pdf",
          "https://example.com/image.png"
        ],
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/messages/email", params)

      assert json_response(conn, 201) == %{"message" => "Message created"}

      conversation = Conversations.get_by_participants(["user@test.com", "contact@example.com"])
      conversation_with_messages = Conversations.get_conversation(conversation.id)
      message = hd(conversation_with_messages.messages)

      assert length(message.attachments) == 2
      assert "https://example.com/document.pdf" in message.attachments
    end

    test "automatically sets type to email regardless of input", %{conn: conn} do
      # Even if someone tries to set type to something else, it should be email
      params = %{
        "from" => "user@test.com",
        "to" => "contact@example.com",
        "body" => "Test",
        "type" => "sms",
        # This should be overridden
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/messages/email", params)

      assert json_response(conn, 201) == %{"message" => "Message created"}

      conversation = Conversations.get_by_participants(["user@test.com", "contact@example.com"])
      conversation_with_messages = Conversations.get_conversation(conversation.id)
      message = hd(conversation_with_messages.messages)

      # Type should be email, not sms
      assert message.type == "email"
    end

    test "returns 400 when required fields are missing", %{conn: conn} do
      invalid_params = %{
        "from" => "user@test.com"
        # Missing to, body, timestamp
      }

      conn = post(conn, ~p"/api/messages/email", invalid_params)

      assert json_response(conn, 400)["errors"]["detail"] =~ "Missing required fields"
      assert json_response(conn, 400)["errors"]["detail"] =~ "to"
    end

    test "handles plain text email body", %{conn: conn} do
      params = %{
        "from" => "user@test.com",
        "to" => "contact@example.com",
        "body" => "Plain text email body",
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/messages/email", params)

      assert json_response(conn, 201) == %{"message" => "Message created"}
    end
  end

  describe "sms_webhook/2" do
    test "returns 200 when message with messaging_provider_id exists", %{conn: conn} do
      insert(:sms_message,
        from: "+18045551234",
        to: "+12016661234",
        type: "sms",
        body: "Incoming SMS",
        messaging_provider_id: "twilio-msg-123"
      )

      # Now send webhook with the same messaging_provider_id
      webhook_params = %{
        "from" => "+18045551234",
        "to" => "+12016661234",
        "type" => "sms",
        "messaging_provider_id" => "twilio-msg-123",
        "body" => "Incoming SMS",
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/webhooks/sms", webhook_params)

      assert json_response(conn, 200) == %{"message" => "Message updated"}
    end

    test "returns 200 when MMS message with messaging_provider_id exists", %{conn: conn} do
      insert(:sms_message,
        from: "+18045551234",
        to: "+12016661234",
        type: "mms",
        body: "Incoming MMS",
        attachments: ["https://example.com/media.jpg"],
        messaging_provider_id: "twilio-mms-456"
      )

      # Send webhook for the MMS
      webhook_params = %{
        "from" => "+18045551234",
        "to" => "+12016661234",
        "type" => "mms",
        "messaging_provider_id" => "twilio-mms-456",
        "body" => "Incoming MMS",
        "attachments" => ["https://example.com/media.jpg"],
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/webhooks/sms", webhook_params)

      assert json_response(conn, 200) == %{"message" => "Message updated"}
    end

    test "returns 404 when message with messaging_provider_id does not exist", %{conn: conn} do
      webhook_params = %{
        "from" => "+18045551234",
        "to" => "+12016661234",
        "type" => "sms",
        "messaging_provider_id" => "nonexistent-msg-id",
        "body" => "Incoming SMS",
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/webhooks/sms", webhook_params)

      assert json_response(conn, 404) == %{"message" => "Message not found"}
    end

    test "returns 404 when messaging_provider_id is nil", %{conn: conn} do
      webhook_params = %{
        "from" => "+18045551234",
        "to" => "+12016661234",
        "type" => "sms",
        "body" => "Incoming SMS",
        "timestamp" => "2024-11-01T14:00:00Z"
        # messaging_provider_id is missing
      }

      conn = post(conn, ~p"/api/webhooks/sms", webhook_params)

      assert json_response(conn, 404) == %{"message" => "Message not found"}
    end
  end

  describe "email_webhook/2" do
    test "returns 200 when message with xillio_id exists", %{conn: conn} do
      insert(:email_message,
        from: "user@usehatchapp.com",
        to: "contact@gmail.com",
        body: "<html><body>Outbound email</body></html>",
        messaging_provider_id: "sendgrid-email-789"
      )

      # Now send webhook with xillio_id matching the messaging_provider_id
      webhook_params = %{
        "from" => "user@usehatchapp.com",
        "to" => "contact@gmail.com",
        "xillio_id" => "sendgrid-email-789",
        "body" => "<html><body>html is <b>allowed</b> here</body></html>",
        "attachments" => ["https://example.com/attachment.pdf"],
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/webhooks/email", webhook_params)

      assert json_response(conn, 200) == %{"message" => "Message updated"}
    end

    test "returns 200 when email message without attachments exists", %{conn: conn} do
      insert(:email_message,
        from: "sender@example.com",
        to: "recipient@example.com",
        body: "Plain email body",
        messaging_provider_id: "sendgrid-email-999"
      )

      # Send webhook
      webhook_params = %{
        "from" => "sender@example.com",
        "to" => "recipient@example.com",
        "xillio_id" => "sendgrid-email-999",
        "body" => "Plain email body",
        "attachments" => [],
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/webhooks/email", webhook_params)

      assert json_response(conn, 200) == %{"message" => "Message updated"}
    end

    test "returns 404 when message with xillio_id does not exist", %{conn: conn} do
      webhook_params = %{
        "from" => "user@usehatchapp.com",
        "to" => "contact@gmail.com",
        "xillio_id" => "nonexistent-email-id",
        "body" => "<html><body>Incoming email</body></html>",
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/webhooks/email", webhook_params)

      assert json_response(conn, 404) == %{"message" => "Message not found"}
    end

    test "returns 404 when xillio_id is nil", %{conn: conn} do
      webhook_params = %{
        "from" => "user@usehatchapp.com",
        "to" => "contact@gmail.com",
        "body" => "<html><body>Incoming email</body></html>",
        "timestamp" => "2024-11-01T14:00:00Z"
        # xillio_id is missing
      }

      conn = post(conn, ~p"/api/webhooks/email", webhook_params)

      assert json_response(conn, 404) == %{"message" => "Message not found"}
    end

    test "returns 200 when email with HTML content and attachments exists", %{conn: conn} do
      insert(:email_message,
        from: "contact@gmail.com",
        to: "user@usehatchapp.com",
        body: "<html><body>This is an incoming email with <b>HTML</b> content</body></html>",
        attachments: ["https://example.com/received-document.pdf"],
        messaging_provider_id: "message-3"
      )

      # Send webhook matching the selected JSON from the user
      webhook_params = %{
        "from" => "contact@gmail.com",
        "to" => "user@usehatchapp.com",
        "xillio_id" => "message-3",
        "body" => "<html><body>This is an incoming email with <b>HTML</b> content</body></html>",
        "attachments" => ["https://example.com/received-document.pdf"],
        "timestamp" => "2024-11-01T14:00:00Z"
      }

      conn = post(conn, ~p"/api/webhooks/email", webhook_params)

      assert json_response(conn, 200) == %{"message" => "Message updated"}
    end
  end
end
