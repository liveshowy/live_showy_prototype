defmodule LiveShowy.Users.Custom do
  @moduledoc """
  The most basic form of a user.
  """

  @enforce_keys [:id, :username, :color, :output_device_name]
  defstruct [:id, :username, :color, :output_device_name]

  @doc """
  Returns a custom user with a random UUID.
  """
  def new(%{username: username, color: "#" <> _ = color})
      when is_binary(username) and is_binary(color) do
    %__MODULE__{
      id: UUID.uuid4(),
      username: username,
      color: color,
      output_device_name: nil
    }
  end

  def new(%{username: username}) when is_binary(username) do
    %__MODULE__{
      id: UUID.uuid4(),
      username: username,
      color: "#" <> Faker.Color.rgb_hex(),
      output_device_name: nil
    }
  end

  alias LiveShowy.Users.Custom
  alias LiveShowy.Protocols.User

  defimpl User, for: Map do
    def new(params), do: Custom.new(params)
  end
end
