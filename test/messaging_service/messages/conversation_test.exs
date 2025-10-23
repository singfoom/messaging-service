defmodule MessagingService.Messages.ConversationTest do
  use MessagingService.DataCase

  alias MessagingService.Messages.Conversation

  describe "changeset/2" do
    test "valid changeset with two participants" do
      changeset =
        Conversation.changeset(%Conversation{}, %{
          participants: ["+12016661234", "+18045551234"]
        })

      assert changeset.valid?
    end

    test "invalid changeset with other than two participants" do
      changeset =
        Conversation.changeset(%Conversation{}, %{
          participants: ["+12016661234"]
        })

      refute changeset.valid?
    end
  end
end
