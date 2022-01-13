defmodule LiveShowy.Chat.Message do
  @enforce_keys [:id, :created_at]

  defstruct id: nil,
            user_id: nil,
            created_at: nil,
            updated_at: nil,
            status: :public,
            body: ""

  def new(params \\ %{}) do
    params = Map.drop(params, [:id, :created_at])

    %__MODULE__{
      id: UUID.uuid4(),
      created_at: DateTime.utc_now()
    }
    |> Map.merge(params)
  end
end
