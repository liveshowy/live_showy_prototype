defmodule LiveShowy.Instrument do
  @moduledoc """
  A struct for instruments to be assigned backstage and used for live stage performances.
  """
  @enforce_keys [:id, :created_at]
  defstruct id: nil,
            created_at: nil,
            component: nil,
            output_device: nil,
            input_device: nil,
            octave: 5,
            channel: 1

  def new(params) do
    params = Map.drop(params, [:id, :created_at])

    %__MODULE__{
      id: UUID.uuid4(),
      created_at: DateTime.utc_now()
    }
    |> Map.merge(params)
  end

  @impl Access
  def fetch(term, key) do
    Map.from_struct(term)
    |> Map.fetch(key)
  end
end
