defmodule LiveShowy.UsersTest do
  use ExUnit.Case, async: false
  alias LiveShowy.Users
  doctest Users

  test "add a custom user" do
    username = "owen"
    color = "#ABC123"
    user = Users.put_user(%{username: username, color: color})
    fetched_user = Users.get_user(user.id)

    assert %Users.Custom{} = user
    assert user.username == username
    assert user.color == color
    assert fetched_user.username == username
    assert fetched_user.color == color
  end

  test "add a fake user" do
    user = Users.put_user()
    fetched_user = Users.get_user(user.id)

    assert %Users.Fake{} = user
    assert user.username != nil
    assert user.color != nil
    assert fetched_user.username == user.username
    assert fetched_user.color == user.color
  end
end
