defmodule Loomer.Users.Fake do
  @moduledoc """
  The most basic form of a user.
  """

  @enforce_keys [:id, :username, :token]
  defstruct [:id, :username, :token]

  @doc """
  Returns a fake user with a random UUID and username.
  """
  def new do
    %__MODULE__{
      id: UUID.uuid4(),
      username: Faker.Internet.user_name(),
      token: nil
    }
  end

  alias Loomer.Users.Fake
  alias Loomer.Users.Guest
  alias Loomer.Protocols.User

  defimpl User, for: Atom do
    def new(:fake), do: Fake.new()
    def new(_), do: Guest.new()
  end
end
