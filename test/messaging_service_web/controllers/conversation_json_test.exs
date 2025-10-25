defmodule MessagingServiceWeb.ConversationJsonTest do
  alias MessagingServiceWeb.ConversationJSON
  use MessagingServiceWeb.ConnCase, async: true

  describe "index/1" do
    test "returns json map of multiple conversations without messages" do
      %{id: id_1, participants: participants_1} =
        conversation_1 = insert(:conversation)

      %{id: id_2, participants: participants_2} =
        conversation_2 = insert(:conversation)

      expected_json_map =
        %{
          data: [
            %{id: id_1, participants: participants_1},
            %{id: id_2, participants: participants_2}
          ]
        }

      assert ConversationJSON.index(%{conversations: [conversation_1, conversation_2]}) ==
               expected_json_map
    end
  end

  describe "show/1" do
    test "returns json map of one conversation with no messages" do
      %{id: id, participants: participants} =
        conversation = insert(:conversation)

      expected_json_map =
        %{
          data: %{id: id, participants: participants}
        }

      assert ConversationJSON.show(%{conversation: conversation}) ==
               expected_json_map
    end

    test "returns json map of one conversation with messages" do
      %{id: id, participants: participants} =
        conversation = insert(:conversation)

      %{
        id: message_1_id,
        to: message_1_to,
        from: message_1_from,
        body: message_1_body,
        type: message_1_type,
        attachments: message_1_attachments,
        timestamp: message_1_timestamp
      } = insert(:sms_message, conversation: conversation)

      %{
        id: message_2_id,
        to: message_2_to,
        from: message_2_from,
        body: message_2_body,
        type: message_2_type,
        attachments: message_2_attachments,
        timestamp: message_2_timestamp
      } = insert(:sms_message, conversation: conversation)

      expected_json_map =
        %{
          data: %{
            id: id,
            participants: participants,
            messages: [
              %{
                id: message_1_id,
                to: message_1_to,
                from: message_1_from,
                body: message_1_body,
                type: message_1_type,
                attachments: message_1_attachments,
                timestamp: message_1_timestamp
              },
              %{
                id: message_2_id,
                to: message_2_to,
                from: message_2_from,
                body: message_2_body,
                type: message_2_type,
                attachments: message_2_attachments,
                timestamp: message_2_timestamp
              }
            ]
          }
        }

      conversation_with_messages = conversation |> MessagingService.Repo.preload(:messages)

      assert expected_json_map ==
               ConversationJSON.show(%{conversation: conversation_with_messages})
    end
  end
end
