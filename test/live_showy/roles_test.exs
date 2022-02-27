defmodule LiveShowy.RolesTest do
  use ExUnit.Case, async: true
  alias LiveShowy.Roles
  doctest Roles

  setup do
    %{roles: Roles.list()}
  end

  test "roles list contains required roles", state do
    expected_roles =
      Enum.sort([:attendee, :backstage_performer, :mainstage_performer, :stage_manager])

    actual_roles = Enum.sort(state.roles)
    assert expected_roles == actual_roles
  end
end
