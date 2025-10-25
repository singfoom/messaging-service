defmodule MessagingService.External.SendgridAPI.Req do
  @moduledoc """
  A Req client that implements the SendgridAPI behaviour
  and mocks responses from the SendgridAPI
  """
  @behaviour MessagingService.External.SendgridAPI

  alias MessagingService.Messages.Message
  alias MessagingService.Messages.Conversation

  # Base url: https://api.sendgrid.com (for global users and subusers)

  @impl true
  def send_email(%Message{} = message) do
    {:ok,
     %Req.Response{
       headers: %{"content_type" => "application/json"},
       private: %{},
       trailers: %{"something" => "something"},
       status: 202,
       body: %{sid: "message-#{message.id}"}
     }}
  end

  def send_email(%Conversation{messages: messages}) do
    message = hd(messages)

    {:ok,
     %Req.Response{
       headers: %{"content_type" => "application/json"},
       private: %{},
       trailers: %{"something" => "something"},
       status: 202,
       body: %{sid: "message-#{message.id}"}
     }}
  end
end
