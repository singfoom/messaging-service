defmodule MessagingService.Messages.Message do
  @moduledoc """
  The message schema holds the information about individual messages
  in the system.  Handles different message types via the type attribute.

  Current valid types are ["email", "mms", "sms"]
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Faker.DateTime
  alias MessagingService.Messages.Conversation

  @type t :: %__MODULE__{
          attachments: list(String.t()),
          body: String.t(),
          from: String.t(),
          messaging_provider_id: String.t(),
          timestamp: DateTime.t(),
          to: String.t(),
          type: String.t()
        }

  schema "messages" do
    field :attachments, {:array, :string}
    field :body, :string
    field :from, :string
    field :messaging_provider_id, :string
    field :timestamp, :utc_datetime
    field :to, :string
    field :type, :string
    belongs_to :conversation, Conversation
    timestamps(type: :utc_datetime)
  end

  @allowed_attribtes ~w(from to type body messaging_provider_id attachments timestamp)a
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
