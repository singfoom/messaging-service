defmodule MessagingServiceWeb.MessageController do
  use MessagingServiceWeb, :controller

  alias MessagingService.External.SendgridAPI
  alias MessagingService.External.TwilioAPI
  alias MessagingService.Conversations
  alias MessagingService.Messages

  action_fallback MessagingServiceWeb.FallbackController

  def send_sms(conn, params) do
    atomized_params = convert_keys_to_atoms(params)

    with :ok <- validate_required_fields(atomized_params, [:from, :to]),
         {:ok, result} <- Conversations.find_or_create_conversation_with_message(atomized_params),
         {:ok, %Req.Response{status: status}} <- TwilioAPI.send_sms_message(result) do
      case status do
        201 ->
          conn
          |> put_status(:created)
          |> json(%{message: "Message created"})
      end
    end
  end

  def send_email(conn, params) do
    params = Map.merge(params, %{"type" => "email"})
    atomized_params = convert_keys_to_atoms(params)

    with :ok <- validate_required_fields(atomized_params, [:from, :to]),
         {:ok, result} <-
           Conversations.find_or_create_conversation_with_message(atomized_params),
         {:ok, %Req.Response{status: status}} <- SendgridAPI.send_email(result) do
      case status do
        202 ->
          conn
          |> put_status(:created)
          |> json(%{message: "Message created"})
      end
    end
  end

  def sms_webhook(conn, params) do
    atomized_params = convert_keys_to_atoms(params)

    case Messages.get_by_messaging_provider_id(Map.get(atomized_params, :messaging_provider_id)) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Message not found"})

      _message ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Message updated"})
    end
  end

  def email_webhook(conn, params) do
    atomized_params = convert_keys_to_atoms(params)

    case Messages.get_by_messaging_provider_id(Map.get(atomized_params, :xillio_id)) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Message not found"})

      _message ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Message updated"})
    end
  end

  defp convert_keys_to_atoms(map) do
    Enum.reduce(map, %{}, fn {key, value}, acc ->
      Map.put(acc, String.to_atom(key), value)
    end)
  end

  defp validate_required_fields(params, required_fields) do
    missing_fields =
      Enum.filter(required_fields, fn field ->
        not Map.has_key?(params, field) or is_nil(Map.get(params, field))
      end)

    case missing_fields do
      [] -> :ok
      fields -> {:error, {:bad_request, "Missing required fields: #{Enum.join(fields, ", ")}"}}
    end
  end
end
