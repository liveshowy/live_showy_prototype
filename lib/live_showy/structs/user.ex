defmodule LiveShowy.Structs.User do
  @enforce_keys [:id, :username, :color]
  defstruct [:id, :username, :color]
end
