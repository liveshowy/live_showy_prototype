defmodule LiveShowy.MidiDevicesTest do
  use ExUnit.Case, async: false
  alias LiveShowy.MidiDevices
  doctest MidiDevices

  describe "list/0" do
    test "device list returns a list" do
      assert is_list(MidiDevices.list())
    end
  end

  describe "add/1" do
    test "a portmidi output device may be added" do
      device = %PortMidi.Device{
        input: 0,
        interf: "CoreMIDI",
        name: "IAC Device Bus 1",
        opened: 0,
        output: 1
      }

      assert {:ok, {:output, _pid, %PortMidi.Device{} = _added_device}} = MidiDevices.add(device)
    end

    test "a portmidi input device may be added" do
      device = %PortMidi.Device{
        input: 1,
        interf: "CoreMIDI",
        name: "IAC Device Bus 1",
        opened: 0,
        output: 0
      }

      assert {:ok, {:input, _pid, %PortMidi.Device{} = _added_device}} = MidiDevices.add(device)
    end

    test "an already open portmidi input device may not be added" do
      device = %PortMidi.Device{
        input: 1,
        interf: "CoreMIDI",
        name: "IAC Device Bus 1",
        opened: 1,
        output: 0
      }

      assert {:error, _message} = MidiDevices.add(device)
    end
  end

  describe "remove/1" do
    test "an added device may be removed" do
      device = %PortMidi.Device{
        input: 0,
        interf: "CoreMIDI",
        name: "IAC Device Bus 1",
        opened: 0,
        output: 1
      }

      {:ok, {:output, _pid, added_device}} = MidiDevices.add(device)
      assert {:ok, _deleted_device} = MidiDevices.remove(added_device)
    end
  end

  describe "get_by_name/2" do
    test "an added device may be found by its type and name" do
      device = %PortMidi.Device{
        input: 0,
        interf: "CoreMIDI",
        name: "IAC Device Bus 1",
        opened: 0,
        output: 1
      }

      assert {:ok, {:output, _pid, %PortMidi.Device{} = added_device}} = MidiDevices.add(device)
      added_device_name = added_device.name

      assert {:output, _pid, ^added_device} = MidiDevices.get_by_name(:output, added_device_name)
    end
  end

  describe "get_by_pid/1" do
    test "an added device may be found by its pid" do
      device = %PortMidi.Device{
        input: 0,
        interf: "CoreMIDI",
        name: "IAC Device Bus 1",
        opened: 0,
        output: 1
      }

      {:ok, {:output, pid, added_device}} = MidiDevices.add(device)
      assert {:output, ^pid, found_device} = MidiDevices.get_by_pid(pid)
      assert %PortMidi.Device{} = found_device
      assert found_device == added_device
    end
  end
end
