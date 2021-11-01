defprotocol Loomer.Protocols.User do
  @fallback_to_any true

  @enforce_keys [:id, :username, :color, :x, :y, :token]
  defstruct [:id, :username, :color, :x, :y, :token]

  @spec new(binary()) :: User.t()
  def new(username)
end
