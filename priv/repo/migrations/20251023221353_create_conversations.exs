defmodule MessagingService.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def up do
    create_if_not_exists table(:conversations) do
      add :participants, {:array, :string}
      add :timestamp, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create_if_not_exists index(:conversations, :participants, using: :gin)
  end

  def down do
    drop_if_exists table(:messages)
    drop_if_exists index(:conversations, :participants)
  end
end
