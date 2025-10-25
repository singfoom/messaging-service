defmodule MessagingService.External.TwilioAPI.Req do
  @moduledoc """
  A Req client that implements the TwilioAPI behaviour
  and mocks responses from the Twilio API
  """

  @behaviour MessagingService.External.TwilioAPI

  # POST https://api.twilio.com/2010-04-01/Accounts/{AccountSid}/Messages.json

  @impl true
  def send_mms_message(message) do
    IO.inspect(message, label: "mms MESSAGE")

    %Req.Response{
      headers: [
        content_type: "application/json"
      ],
      status: 200,
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
        sid: "SMaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        status: "queued",
        to: message.to,
        uri:
          "/2010-04-01/Accounts/ACaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa/Messages/SMaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.json"
      }
    }
  end

  @impl true
  def send_sms_message(message) do
    IO.inspect(message, label: "sms MESSAGE")
  end
end
