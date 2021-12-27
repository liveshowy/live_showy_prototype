defprotocol LiveShowy.Protocols.User do
  @fallback_to_any true

  @enforce_keys [:id, :username, :color]
  defstruct [:id, :username, :color]

  @spec new(binary()) :: User.t()
  def new(username)
end
