defmodule MessagingService.Repo.Migrations.AddConversationIdToMessages do
  use Ecto.Migration

  def up do
    alter table("messages") do
      add_if_not_exists :conversation_id, references(:conversations)
    end
  end

  def down do
    alter table("messages") do
      remove_if_exists :conversation_id
    end
  end
end
