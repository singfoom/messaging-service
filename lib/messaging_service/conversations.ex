defmodule MessagingService.Conversations do
  @moduledoc """
  The Conversations context file for handling persistance operations on
  Conversation schema.
  """

  import Ecto.Query, warn: false
  alias MessagingService.Repo
  alias MessagingService.Messages.Conversation
  alias MessagingService.Messages.Message

  @doc """
  Returns the list of conversations.

  ## Examples

      iex> list_conversations()
      [%Conversation{}, ...]

  """
  def list_conversations() do
    Conversation
    |> Repo.all()
  end

  @doc """
  Gets a single conversation with preloaded messages.

  ## Examples

      iex> get_conversation(123)
      %Conversation{}

      iex> get_conversation(456)
      nil

  """
  def get_conversation(conversation_id) do
    Conversation
    |> Repo.get(conversation_id)
    |> Repo.preload(:messages)
  end

  @doc """
  Gets a single conversation by participants.

  ## Examples

      iex> get_by_participants(["hello@test.com", "test@hello.com])
      %Conversation{}

      iex> get_by_participants([])
      nil

  """
  def get_by_participants(participants) when is_list(participants) do
    [p1 | rest] = participants
    p2 = hd(rest)

    query =
      from(c in Conversation,
        where: ^p1 in c.participants,
        where: ^p2 in c.participants
      )

    Repo.one(query)
  end

  @doc """
  Creates a message with a new conversation or creates a new
  message under an existing conversation.

  ## Examples

      iex> find_or_create_conversation_with_message(%{from: "hello@test.com", to: "test@hello.com})
      %Conversation{}

      iex> find_or_create_conversation_with_message(%{from: "hello@test.com", to: "test@hello.com})
      %Message{}

  """
  def find_or_create_conversation_with_message(%{from: from, to: to} = message_params) do
    message_participants = [to, from]

    case get_by_participants(message_participants) do
      nil ->
        conversation_attrs = %{
          participants: message_participants,
          messages: [message_params]
        }

        changeset =
          %Conversation{}
          |> Conversation.changeset(conversation_attrs)
          |> Ecto.Changeset.cast_assoc(:messages)

        # Preload the messages on the conversation
        with {:ok, conversation} <- Repo.insert(changeset) do
          {:ok, Repo.preload(conversation, [:messages])}
        end

      conversation ->
        changeset =
          %Message{}
          |> Message.changeset(message_params)
          |> Ecto.Changeset.put_assoc(:conversation, conversation)

        Repo.insert(changeset)
    end
  end
end
