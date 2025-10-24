defmodule MessagingServiceWeb.ConversationJSON do
  alias MessagingService.Messages.Conversation
  alias MessagingServiceWeb.MessageJSON

  @doc """
  Renders a list of conversations.
  """
  def index(%{conversations: conversations}) do
    %{data: for(conversation <- conversations, do: data(conversation))}
  end

  @doc """
  Renders a single conversation.
  """
  def show(%{conversation: conversation}) do
    %{data: data(conversation)}
  end

  defp data(%Conversation{} = conversation) do
    %{
      id: conversation.id,
      participants: conversation.participants,
      messages:
        if(conversation.messages) do
          MessageJSON.index(%{messages: conversation.messages})[:data]
        else
          []
        end
    }
  end

  defp data(%Conversation{messages: %Ecto.Association.NotLoaded{}} = conversation) do
    %{
      id: conversation.id,
      participants: conversation.participants
    }
  end
end
