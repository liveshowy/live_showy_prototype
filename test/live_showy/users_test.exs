defmodule LiveShowy.UsersTest do
  use ExUnit.Case, async: true
  alias LiveShowy.Users
  doctest Users

  setup do
    %{
      custom_user:
        Users.add(%{
          username: Faker.Internet.user_name(),
          color: Faker.Color.rgb_hex()
        }),
      fake_user: Users.add()
    }
  end

  test "add a custom user", state do
    assert %Users.Custom{} = state.custom_user
    assert Users.get(state.custom_user.id) == state.custom_user
    assert is_binary(state.custom_user.username)
    assert is_binary(state.custom_user.color)
  end

  test "add a fake user", state do
    assert %Users.Fake{} = state.fake_user
    assert Users.get(state.fake_user.id) == state.fake_user
    assert state.fake_user.username != nil
    assert state.fake_user.color != nil
  end
end
