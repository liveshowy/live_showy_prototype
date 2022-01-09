defmodule LiveShowy.RolesTest do
  use ExUnit.Case, async: false
  alias LiveShowy.Roles
  doctest Roles

  test "roles list contains required roles" do
    expected_roles = Enum.sort([:guest, :attendee, :performer, :stage_manager])
    actual_roles = Enum.sort(Roles.list())
    assert expected_roles == actual_roles
  end
end
