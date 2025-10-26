defmodule MessagingService.Repo.Migrations.AddIndexToMessagingProviderId do
  use Ecto.Migration

  def up do
    create_if_not_exists index(:messages, :messaging_provider_id)
  end

  def down do
    drop_if_exists index(:messages, :messaging_provider_id)
  end
end
