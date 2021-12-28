defmodule LiveShowy.UsersTest do
  use ExUnit.Case
  alias LiveShowy.Users
  doctest Users

  test "add a new fake user" do
    user = Users.put_user(:fake)
    assert user.username != nil
  end

  test "users table is not empty" do
    user_list = Users.list_users()
    assert Enum.count(user_list) > 0
  end
end
