defprotocol Loomer.Protocols.User do
  @fallback_to_any true

  @enforce_keys [:id, :username, :token]
  defstruct [:id, :username, :token]

  @spec new(binary()) :: User.t()
  def new(username)
end
