defmodule MessagingService.Factory do
  @moduledoc """
  An ex machina based factory for data in tests
  """
  use ExMachina.Ecto, repo: MessagingService.Repo

  alias MessagingService.Messages.Conversation
  alias MessagingService.Messages.Message

  def sms_message_factory do
    %Message{
      attachments: [],
      body: Faker.Lorem.Shakespeare.hamlet(),
      from: Faker.Phone.EnUs.phone(),
      messaging_provider_id: nil,
      timestamp: DateTime.utc_now(),
      to: Faker.Phone.EnUs.phone(),
      type: Faker.Util.pick(["sms", "mms"])
    }
  end

  def email_message_factory do
    %Message{
      from: Faker.Internet.email(),
      to: Faker.Internet.email(),
      type: "email",
      attachments: [],
      body: Faker.Lorem.Shakespeare.hamlet(),
      timestamp: DateTime.utc_now()
    }
  end

  def conversation_factory do
    %Conversation{
      participants: [Faker.Internet.email(), Faker.Internet.email()]
    }
  end
end
