defprotocol LiveShowy.Protocols.User do
  alias LiveShowy.Structs.User
  @fallback_to_any true

  @spec new(map()) :: User.t()
  def new(params)
end
