defmodule MessagingService.External.TwilioAPI do
  @callback send_sms_message(Message.t()) :: {:ok, Req.Response.t()} | {:error, Exception.t()}
  @callback send_mms_message(Message.t()) :: {:ok, Req.Response.t()} | {:error, Exception.t()}

  @module Application.compile_env!(:external, :twilio_api)

  defdelegate send_sms_message(message), to: @module
  defdelegate send_mms_message(message), to: @module
end
