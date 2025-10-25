defmodule MessagingService.External.SendgridAPI.Req do
  @moduledoc """
  A Req client that implements the SendgridAPI behaviour
  and mocks responses from the SendgridAPI
  """
  @behaviour MessagingService.External.SendgridAPI

  # Base url: https://api.sendgrid.com (for global users and subusers)

  @impl true
  def send_email(_message) do
    {:ok,
     %Req.Response{
       headers: %{"content_type" => "application/json"},
       private: %{},
       trailers: %{"something" => "something"},
       status: 202,
       body: %{}
     }}
  end
end
