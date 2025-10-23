defmodule MessagingServiceWeb.MessageJSON do
  alias MessagingService.Messages.Message

  @doc """
  Renders a list of messages.
  """
  def index(%{messages: messages}) do
    %{data: for(message <- messages, do: data(message))}
  end

  @doc """
  Renders a single message.
  """
  def show(%{message: message}) do
    %{data: data(message)}
  end

  defp data(%Message{} = message) do
    %{
      id: message.id,
      from: message.from,
      to: message.to,
      type: message.type,
      body: message.body,
      attachments: message.attachments,
      timestamp: message.timestamp
    }
  end
end
