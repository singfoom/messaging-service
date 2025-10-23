defmodule MessagingService.Factory do
  @moduledoc """
  An ex machina based factory for data in tests
  """
  use ExMachina.Ecto, repo: MessagingService.Repo
  alias MessagingService.Messages.Message

  def message_factory do
    %Message{
      from: Faker.Phone.EnUs.phone(),
      to: Faker.Phone.EnUs.phone(),
      type: "sms",
      attachments: [],
      body: Faker.Lorem.Shakespeare.hamlet(),
      timestamp: DateTime.utc_now()
    }
  end
end
