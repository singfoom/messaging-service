defmodule MessagingService.External.TwilioAPI.Req do
  @behaviour MessagingService.External.TwilioAPI

  # POST https://api.twilio.com/2010-04-01/Accounts/{AccountSid}/Messages.json

  @impl true
  def send_mms_message(message) do
    IO.inspect(message, label: "mms MESSAGE")
  end

  @impl true
  def send_sms_message(message) do
    IO.inspect(message, label: "sms MESSAGE")
  end
end
