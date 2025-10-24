defmodule MessagingService.External.SendgridAPI.Req do
  @behaviour MessagingService.External.SendgridAPI

  # Base url: https://api.sendgrid.com (for global users and subusers)

  @impl true
  def send_email(message) do
    IO.inspect(message, label: "EMAIL MESSAGE")
  end
end
