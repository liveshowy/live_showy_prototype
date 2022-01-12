defmodule LiveShowy.MidiDevicesTest do
  use ExUnit.Case, async: true
  alias LiveShowy.MidiDevices
  doctest MidiDevices

  setup do
    device = %PortMidi.Device{
      input: 0,
      interf: "CoreMIDI",
      name: "IAC Device Bus 1",
      opened: 0,
      output: 1
    }

    {:ok, {:output, pid, added_device}} = MidiDevices.add(device)

    %{
      device: device,
      added_device: added_device,
      pid: pid
    }
  end

  describe "list/0" do
    test "device list returns a list", state do
      results = MidiDevices.list()
      assert is_list(results)

      assert Enum.any?(results, fn {_type, _pid, device} ->
               device.name == state.added_device.name
             end)
    end
  end

  describe "add/1" do
    test "a portmidi device may be added", state do
      assert %PortMidi.Device{} = state.added_device
    end

    test "an already open portmidi input device may not be added", state do
      assert {:error, _message} = MidiDevices.add(state.device)
    end
  end

  describe "remove/1" do
    test "an added device may be removed", state do
      assert {:ok, _deleted_device} = MidiDevices.remove(state.added_device)
    end
  end

  describe "get_by_name/2" do
    test "an added device may be found by its type and name", state do
      added_device = state.added_device
      assert {:output, _pid, ^added_device} = MidiDevices.get_by_name(:output, added_device.name)
    end
  end
end
