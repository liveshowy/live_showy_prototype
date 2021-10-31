defmodule Loomer.Users.Fake do
  @moduledoc """
  The most basic form of a user.
  """

  @enforce_keys [:id, :username, :x, :y, :color, :token]
  defstruct [:id, :username, :x, :y, :color, :token]

  @doc """
  Returns a fake user with a random UUID and username.
  """
  def new do
    %__MODULE__{
      id: UUID.uuid4(),
      username: Faker.Internet.user_name(),
      color: "#" <> Faker.Color.rgb_hex(),
      x: Enum.random(10..90) |> Integer.to_string() |> String.pad_leading(3, "0"),
      y: Enum.random(10..90) |> Integer.to_string() |> String.pad_leading(3, "0"),
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
