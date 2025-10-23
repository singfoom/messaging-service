defmodule MessagingService.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def up do
    create_if_not_exists table(:messages) do
      add :from, :string
      add :to, :string
      add :type, :string
      add :body, :text
      add :attachments, {:array, :string}
      add :timestamp, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end

  def down do
    drop_if_exists table(:messages)
  end
end
