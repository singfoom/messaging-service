defmodule MessagingService.Messages.Message do
  @moduledoc """
  The message schema holds the information about individual messages
  in the system.  Handles different message types via the type attribute.

  Current valid types are ["email", "mms", "sms"]
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias MessagingService.Messages.Conversation

  schema "messages" do
    field :timestamp, :utc_datetime
    field :type, :string
    field :body, :string
    field :to, :string
    field :from, :string
    field :attachments, {:array, :string}
    belongs_to :conversation, Conversation
    timestamps(type: :utc_datetime)
  end

  @allowed_attribtes ~w(from to type body attachments timestamp)a
  @allowed_types ~w(email mms sms)

  @required_attributes ~w(from to type body timestamp)a

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, @allowed_attribtes)
    |> validate_required(@required_attributes)
    |> validate_inclusion(:type, @allowed_types)
  end
end
