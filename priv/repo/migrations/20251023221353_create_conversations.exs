defmodule MessagingService.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def up do
    create_if_not_exists table(:conversations) do
      add :timestamp, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end

  def down do
    drop_if_exists table(:messages)
  end
end
