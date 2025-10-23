defmodule MessagingService.Messages.Conversation do
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
