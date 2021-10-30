defmodule Loomer.Users.Guest do
  @moduledoc """
  The most basic form of a user.
  """

  @enforce_keys [:id, :username, :token]
  defstruct [:id, :username, :token]

  @doc """
  Returns a guest user with a random UUID and username.
  """
  def new do
    %__MODULE__{
      id: nil,
      username: nil,
      token: nil
    }
  end

  alias Loomer.Users.Guest
  alias Loomer.Protocols.User

  defimpl User, for: [Guest, Any] do
    def new(_username), do: Guest.new()
  end
end
