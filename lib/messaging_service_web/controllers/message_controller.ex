defmodule MessagingServiceWeb.MessageController do
  use MessagingServiceWeb, :controller

  alias MessagingService.Conversations
  # alias MessagingService.Messages
  # alias MessagingService.Messages.Message

  action_fallback MessagingServiceWeb.FallbackController

  def send_sms(conn, params) do
    atomized_params = convert_keys_to_atoms(params)

    with {:ok, _result} <- Conversations.find_or_create_conversation_with_message(atomized_params) do
      conn
      |> put_status(:created)
    end
  end

  def send_email(conn, params) do
    params = Map.merge(params, %{"type" => "email"})
    atomized_params = convert_keys_to_atoms(params)

    with {:ok, _result} <- Conversations.find_or_create_conversation_with_message(atomized_params) do
      conn
      |> put_status(:created)
    end
  end

  defp convert_keys_to_atoms(map) do
    Enum.reduce(map, %{}, fn {key, value}, acc ->
      Map.put(acc, String.to_atom(key), value)
    end)
  end
end
