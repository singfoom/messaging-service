defmodule MessagingServiceWeb.ConversationController do
  use MessagingServiceWeb, :controller

  alias MessagingService.Conversations

  action_fallback MessagingServiceWeb.FallbackController

  def index(conn, _params) do
    conversations = Conversations.list_conversations()
    render(conn, :index, conversations: conversations)
  end

  def show(conn, %{"id" => id}) do
    case Conversations.get_conversation(id) do
      nil -> {:error, :not_found}
      conversation -> render(conn, :show, conversation: conversation)
    end
  end
end
