defmodule LiveShowy.Users.Guest do
  @moduledoc """
  The most basic form of a user.
  """

  @enforce_keys [:id, :username, :color, :x, :y, :token]
  defstruct [:id, :username, :color, :x, :y, :token]

  @doc """
  Returns a guest user with a random UUID and username.
  """
  def new do
    %__MODULE__{
      id: UUID.uuid4(),
      username: nil,
      color: "#" <> Faker.Color.rgb_hex(),
      x: Enum.random(10..90) |> Integer.to_string() |> String.pad_leading(3, "0"),
      y: Enum.random(10..90) |> Integer.to_string() |> String.pad_leading(3, "0"),
      token: nil
    }
  end

  alias LiveShowy.Users.Guest
  alias LiveShowy.Protocols.User

  defimpl User, for: [Guest, Any] do
    def new(_username), do: Guest.new()
  end
end
