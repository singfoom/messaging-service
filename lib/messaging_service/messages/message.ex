defmodule MessagingService.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :timestamp, :utc_datetime
    field :type, :string
    field :body, :string
    field :to, :string
    field :from, :string
    field :attachments, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @allowed_attribtes ~w(from to type body attachments timestamp)a

  @required_attributes ~w(from to type body attachments timestamp)a

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, @allowed_attribtes)
    |> validate_required(@required_attributes)
  end
end
