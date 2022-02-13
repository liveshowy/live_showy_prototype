defmodule LiveShowy.Users.Fake do
  @moduledoc """
  The most basic form of a user.
  """

  @enforce_keys [:id, :username, :color, :output_device_name]
  defstruct [:id, :username, :color, :output_device_name]

  @doc """
  Returns a fake user with a random UUID and username.
  """
  def new do
    %__MODULE__{
      id: UUID.uuid4(),
      username: Faker.Internet.user_name(),
      color: "#" <> Faker.Color.rgb_hex(),
      output_device_name: nil
    }
  end

  alias LiveShowy.Users.Fake
  alias LiveShowy.Protocols.User

  defimpl User, for: Any do
    def new(_), do: Fake.new()
  end
end
