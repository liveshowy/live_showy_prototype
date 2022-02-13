defmodule LiveShowy.MidiDevicesTest do
  use ExUnit.Case, async: true
  alias LiveShowy.MidiDevices
  doctest MidiDevices

  # The following tests depend on a virtual MIDI device enabled in MacOS.

  describe "get_devices/1" do
    test "get list of input devices" do
      devices = MidiDevices.get_devices(:input)
      assert is_list(devices)
    end

    test "get list of output devices" do
      devices = MidiDevices.get_devices(:output)
      assert is_list(devices)
    end
  end

  describe "write/2" do
    test "an opened output may receive messages" do
      type = :output
      name = "IAC Device Bus 1"

      assert :ok == MidiDevices.write(name, {144, 60, 127})
      Process.sleep(100)
      assert :ok == MidiDevices.write(name, {128, 60, 0})
      Process.sleep(100)

      assert :ok ==
               MidiDevices.write(
                 name,
                 {{144, 60, 127}, DateTime.to_unix(DateTime.now!("UTC"))}
               )

      Process.sleep(100)

      assert :ok ==
               MidiDevices.write(
                 name,
                 {{128, 60, 0}, DateTime.to_unix(DateTime.now!("UTC"))}
               )

      Process.sleep(100)
    end
  end
end
