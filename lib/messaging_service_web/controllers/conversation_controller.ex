defmodule MessagingServiceWeb.ConversationController do
  use MessagingServiceWeb, :controller

  alias MessagingService.Conversations
  # alias MessagingService.Messages
  # alias MessagingService.Messages.Message

  action_fallback MessagingServiceWeb.FallbackController

  def index(conn, _params) do
    conversations = Conversations.list_conversations()
    render(conn, :index, conversations: conversations)
  end

  def show(conn, %{"id" => id}) do
    conversation = Conversations.get_conversation(id)
    render(conn, :show, conversation: conversation)
  end
end
