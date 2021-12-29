defmodule LiveShowy.RolesTest do
  use ExUnit.Case, async: false
  alias LiveShowy.Roles
  doctest Roles

  test "roles list contains required roles" do
    roles = Roles.list_roles()
    assert [:guest, :attendee, :performer, :stage_manager] = Keyword.keys(roles)
  end
end
