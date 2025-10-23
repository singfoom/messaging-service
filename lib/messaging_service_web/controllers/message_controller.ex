defmodule MessagingServiceWeb.MessageController do
  use MessagingServiceWeb, :controller

  alias MessagingService.Messages
  alias MessagingService.Messages.Message

  action_fallback MessagingServiceWeb.FallbackController

  def send_sms(conn, params) do
    # Persist the message
    # Create or update conversations
    # Send the sms
    with {:ok, %Message{} = message} <- Messages.create_message(params) do
      conn
      |> put_status(:created)
      |> render(:show, message: message)
    end
  end

  def send_email(conn, params) do
    # Persist the message
    # Create or update conversations
    # Send the email
    params = Map.merge(params, %{"type" => "email"})

    with {:ok, %Message{} = message} <- Messages.create_message(params) do
      conn
      |> put_status(:created)
      |> render(:show, message: message)
    end
  end
end
