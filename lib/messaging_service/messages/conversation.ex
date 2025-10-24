defmodule MessagingService.Messages.Conversation do
  @moduledoc """
  The conversation schema holds the information about a conversation
  between ONLY two participants.  It provides a schema to group those
  messages together as they are persisted.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias MessagingService.Messages.Message

  schema "conversations" do
    field :participants, {:array, :string}
    has_many :messages, Message
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:participants])
    |> validate_required([:participants])
    |> validate_length(:participants, is: 2)
  end
end
