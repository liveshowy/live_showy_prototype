defmodule LiveShowy.UserInstrumentsTest do
  use ExUnit.Case, async: true
  alias LiveShowy.Users
  alias LiveShowy.Instrument
  alias LiveShowy.UserInstruments
  doctest UserInstruments

  setup do
    user = Users.add(%{username: Faker.Internet.user_name()})
    instrument = Instrument.new(%{octave: 5})

    %{
      user: user,
      instrument: instrument,
      user_instrument: UserInstruments.add({user.id, instrument})
    }
  end

  test "user instrument is added", state do
    user_id = state.user.id
    instrument_id = state.instrument.id
    assert {^user_id, %Instrument{id: ^instrument_id}} = state.user_instrument
  end

  test "user instrument may be retrieved", state do
    user_instrument = state.user_instrument
    assert ^user_instrument = UserInstruments.get(state.user.id)
  end

  test "user instrument may be removed", state do
    UserInstruments.remove(state.user.id)
    assert nil == UserInstruments.get(state.user.id)
  end
end
