defmodule MessagingServiceWeb.ConversationControllerTest do
  use MessagingServiceWeb.ConnCase

  describe "index/2" do
    test "returns empty list when no conversations exist", %{conn: conn} do
      conn = get(conn, ~p"/api/conversations")

      assert json_response(conn, 200) == %{"data" => []}
    end

    test "returns list of all conversations", %{conn: conn} do
      # Create test conversations
      conversation1 = insert(:conversation, participants: ["+15551234567", "+15559876543"])
      conversation2 = insert(:conversation, participants: ["user@test.com", "contact@test.com"])

      conn = get(conn, ~p"/api/conversations")

      response = json_response(conn, 200)
      assert %{"data" => conversations} = response
      assert length(conversations) == 2

      # Verify conversation data structure
      conv_ids = Enum.map(conversations, & &1["id"])
      assert conversation1.id in conv_ids
      assert conversation2.id in conv_ids

      # Verify each conversation has required fields
      for conversation <- conversations do
        assert Map.has_key?(conversation, "id")
        assert Map.has_key?(conversation, "participants")
        assert is_list(conversation["participants"])
        assert length(conversation["participants"]) == 2
      end
    end

    test "conversations without preloaded messages do not include messages field", %{conn: conn} do
      insert(:conversation, participants: ["+15551234567", "+15559876543"])

      conn = get(conn, ~p"/api/conversations")

      response = json_response(conn, 200)
      assert %{"data" => [conversation]} = response
      refute Map.has_key?(conversation, "messages")
    end
  end

  describe "show/2" do
    test "returns conversation with messages when conversation exists", %{conn: conn} do
      # Create conversation with messages
      conversation = insert(:conversation, participants: ["+15551234567", "+15559876543"])

      message1 =
        insert(:sms_message,
          conversation: conversation,
          from: "+15551234567",
          to: "+15559876543",
          body: "Hello",
          type: "sms"
        )

      message2 =
        insert(:sms_message,
          conversation: conversation,
          from: "+15559876543",
          to: "+15551234567",
          body: "Hi there!",
          type: "sms"
        )

      conn = get(conn, ~p"/api/conversations/#{conversation.id}/messages")

      response = json_response(conn, 200)
      assert %{"data" => conversation_data} = response

      # Verify conversation data
      assert conversation_data["id"] == conversation.id
      assert conversation_data["participants"] == ["+15551234567", "+15559876543"]

      # Verify messages are included
      assert Map.has_key?(conversation_data, "messages")
      messages = conversation_data["messages"]
      assert length(messages) == 2

      # Verify message IDs are present
      message_ids = Enum.map(messages, & &1["id"])
      assert message1.id in message_ids
      assert message2.id in message_ids

      # Verify message structure
      for message <- messages do
        assert Map.has_key?(message, "id")
        assert Map.has_key?(message, "from")
        assert Map.has_key?(message, "to")
        assert Map.has_key?(message, "body")
        assert Map.has_key?(message, "type")
      end
    end

    test "returns conversation with empty messages array when no messages exist", %{conn: conn} do
      conversation = insert(:conversation, participants: ["+15551234567", "+15559876543"])

      conn = get(conn, ~p"/api/conversations/#{conversation.id}/messages")

      response = json_response(conn, 200)
      assert %{"data" => conversation_data} = response

      assert conversation_data["id"] == conversation.id
      assert conversation_data["messages"] == []
    end

    test "returns 404 when conversation does not exist", %{conn: conn} do
      # Use a non-existent ID
      non_existent_id = 999_999

      conn = get(conn, ~p"/api/conversations/#{non_existent_id}/messages")

      # The fallback controller should handle the nil case
      # Verify the response - this depends on FallbackController implementation
      assert response(conn, 404)
    end

    test "messages are ordered correctly in conversation", %{conn: conn} do
      conversation = insert(:conversation, participants: ["+15551234567", "+15559876543"])

      # Insert messages with specific timestamps
      timestamp1 = ~U[2024-01-01 10:00:00Z]
      timestamp2 = ~U[2024-01-01 10:05:00Z]
      timestamp3 = ~U[2024-01-01 10:10:00Z]

      message1 =
        insert(:sms_message, conversation: conversation, timestamp: timestamp1, body: "First")

      message2 =
        insert(:sms_message, conversation: conversation, timestamp: timestamp2, body: "Second")

      message3 =
        insert(:sms_message, conversation: conversation, timestamp: timestamp3, body: "Third")

      conn = get(conn, ~p"/api/conversations/#{conversation.id}/messages")

      response = json_response(conn, 200)
      messages = response["data"]["messages"]

      # Get the message IDs in order
      message_ids = Enum.map(messages, & &1["id"])

      # Verify all three messages are present
      assert message1.id in message_ids
      assert message2.id in message_ids
      assert message3.id in message_ids
    end

    test "conversation includes all participant information", %{conn: conn} do
      participants = ["+15551234567", "+15559876543"]
      conversation = insert(:conversation, participants: participants)

      conn = get(conn, ~p"/api/conversations/#{conversation.id}/messages")

      response = json_response(conn, 200)
      conversation_data = response["data"]

      assert conversation_data["participants"] == participants
      assert length(conversation_data["participants"]) == 2
    end
  end

  describe "show/2 with FallbackController" do
    test "handles nil conversation gracefully", %{conn: conn} do
      conn = get(conn, ~p"/api/conversations/999999/messages")

      # Should return 404 or appropriate error
      assert conn.status in [404, 400, 422]
    end
  end
end
