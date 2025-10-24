defmodule MessagingService.External.SendgridAPI do
  @callback send_email(Message.t()) :: {:ok, Req.Response.t()} | {:error, Exception.t()}

  @module Application.compile_env!(:external, :sendgrid_api)

  defdelegate send_email(message), to: @module
end
