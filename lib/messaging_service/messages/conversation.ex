defmodule MessagingService.Messages.Conversation do
  use Ecto.Schema

  alias MessagingService.Messages.Message

  schema "conversations" do
    field :attachments, {:array, :string}
    has_many :messages, Message
    timestamps(type: :utc_datetime)
  end
end
