defmodule MessagingService.Repo.Migrations.AddMessagingProviderIdToMessages do
  use Ecto.Migration

  def up do
    alter table(:messages) do
      add_if_not_exists(:messaging_provider_id, :string)
    end
  end

  def down do
    alter table(:messages) do
      remove_if_exists(:messaging_provider_id)
    end
  end
end
