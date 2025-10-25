defmodule MessagingService.External.SendgridAPI do
  @moduledoc """
  A behaviour that defines the interface with the Sendgrid API
  """

  @callback send_email(Message.t()) :: {:ok, Req.Response.t()} | {:error, Exception.t()}

  @module Application.compile_env!(:messaging_service, :sendgrid_api)

  defdelegate send_email(message), to: @module
end
