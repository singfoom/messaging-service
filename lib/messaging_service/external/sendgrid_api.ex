defmodule MessagingService.External.SendgridAPI do
  @moduledoc """
  A behaviour that defines the interface with the Sendgrid API
  """
  alias MessagingService.Messages.Message
  alias MessagingService.Messages.Conversation

  @callback send_email(Message.t() | Conversation.t()) ::
              {:ok, Req.Response.t()} | {:error, Exception.t()}

  @module Application.compile_env!(:messaging_service, :sendgrid_api)

  defdelegate send_email(message), to: @module
end
