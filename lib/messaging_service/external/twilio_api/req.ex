defmodule MessagingService.External.TwilioAPI.Req do
  @moduledoc """
  A Req client that implements the TwilioAPI behaviour
  and mocks responses from the Twilio API
  """

  @behaviour MessagingService.External.TwilioAPI

  alias MessagingService.Messages.Conversation
  alias MessagingService.Messages.Message

  # POST https://api.twilio.com/2010-04-01/Accounts/{AccountSid}/Messages.json

  @impl true
  def send_sms_message(%Message{} = message) do
    generate_response(message)
  end

  @impl true
  def send_sms_message(%Conversation{messages: messages}) do
    message = hd(messages)
    generate_response(message)
  end

  defp generate_response(message) do
    {:ok,
     %Req.Response{
       headers: %{"content_type" => "application/json"},
       private: %{},
       trailers: %{"something" => "something"},
       status: 201,
       body: %{
         account_sid: "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
         api_version: "2010-04-01",
         body: message.body,
         date_created: "Thu, 24 Aug 2023 05:01:45 +0000",
         date_sent: "Thu, 24 Aug 2023 05:01:45 +0000",
         date_updated: "Thu, 24 Aug 2023 05:01:45 +0000",
         direction: "outbound-api",
         error_code: nil,
         error_message: nil,
         from: message.from,
         num_media: "0",
         num_segments: "1",
         price: nil,
         price_unit: nil,
         messaging_service_sid: "MGaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
         sid: "message-#{message.id}",
         status: "queued",
         to: message.to,
         uri:
           "/2010-04-01/Accounts/ACaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa/Messages/SMaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.json"
       }
     }}
  end
end
