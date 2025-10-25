defmodule MessagingService.External.TwilioAPI do
  @moduledoc """
  A behaviour that defines the interface with the Twilio API
  """

  @callback send_sms_message(Message.t()) :: {:ok, Req.Response.t()} | {:error, Exception.t()}
  @callback send_mms_message(Message.t()) :: {:ok, Req.Response.t()} | {:error, Exception.t()}

  @module Application.compile_env!(:messaging_service, :twilio_api)

  defdelegate send_sms_message(message), to: @module
  defdelegate send_mms_message(message), to: @module
end
