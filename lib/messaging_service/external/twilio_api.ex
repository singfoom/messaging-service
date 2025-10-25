defmodule MessagingService.External.TwilioAPI do
  @moduledoc """
  A behaviour that defines the interface with the Twilio API
  """
  alias MessagingService.Messages.Message
  alias MessagingService.Messages.Conversation

  @callback send_sms_message(Message.t() | Conversation.t()) ::
              {:ok, Req.Response.t()} | {:error, Exception.t()}

  @module Application.compile_env!(:messaging_service, :twilio_api)

  defdelegate send_sms_message(message), to: @module
end
