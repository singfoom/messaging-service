defmodule MessagingService.Repo.Migrations.IndexToAndFromInMessages do
  use Ecto.Migration

  def up do
    create_if_not_exists index(:messages, :to)
    create_if_not_exists index(:messages, :from)
  end

  def down do
    drop_if_exists index(:messages, :to)
    drop_if_exists index(:messages, :from)
  end
end
