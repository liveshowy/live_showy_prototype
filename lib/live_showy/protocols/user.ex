defprotocol LiveShowy.Protocols.User do
  @fallback_to_any true

  @enforce_keys [:id, :username, :color, :token]
  defstruct [:id, :username, :color, :token]

  @spec new(binary()) :: User.t()
  def new(username)
end
