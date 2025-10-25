defmodule MessagingServiceWeb.MessageJsonTest do
  alias MessagingServiceWeb.MessageJSON
  use MessagingServiceWeb.ConnCase, async: true

  describe "index/1" do
    test "returns json map of multiple messages" do
      %{
        id: message_1_id,
        to: message_1_to,
        from: message_1_from,
        body: message_1_body,
        type: message_1_type,
        attachments: message_1_attachments,
        timestamp: message_1_timestamp
      } =
        message_1 = insert(:sms_message)

      %{
        id: message_2_id,
        to: message_2_to,
        from: message_2_from,
        body: message_2_body,
        type: message_2_type,
        attachments: message_2_attachments,
        timestamp: message_2_timestamp
      } =
        message_2 = insert(:sms_message)

      expected_json_map = %{
        data: [
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

      assert MessageJSON.index(%{messages: [message_1, message_2]}) ==
               expected_json_map
    end
  end

  describe "show/1" do
    test "returns json map of one message" do
      %{
        id: message_id,
        to: message_to,
        from: message_from,
        body: message_body,
        type: message_type,
        attachments: message_attachments,
        timestamp: message_timestamp
      } =
        message = insert(:sms_message)

      expected_json_map = %{
        data: %{
          id: message_id,
          to: message_to,
          from: message_from,
          body: message_body,
          type: message_type,
          attachments: message_attachments,
          timestamp: message_timestamp
        }
      }

      assert MessageJSON.show(%{message: message}) ==
               expected_json_map
    end
  end
end
