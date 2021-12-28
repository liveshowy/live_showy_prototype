defprotocol LiveShowy.Protocols.User do
  @fallback_to_any true

  def new(params)
end
