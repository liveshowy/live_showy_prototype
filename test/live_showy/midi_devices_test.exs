defmodule LiveShowy.MidiDevicesTest do
  use ExUnit.Case, async: true
  alias LiveShowy.MidiDevices
  doctest MidiDevices

  # The following tests depend on a virtual MIDI device enabled in MacOS. Thus, these tests handle possible `:ok` and `:error` tuples.

  describe "open/2" do
    test "a valid output may be opened" do
      type = :output
      name = "IAC Device Bus 1"

      case MidiDevices.open(type, name) do
        {:ok, device_pid} ->
          assert is_pid(device_pid)
          MidiDevices.close(type, name)

        {:error, reason} ->
          assert is_atom(reason)
      end
    end
  end

  describe "close/2" do
    test "an opened output may be closed" do
      type = :output
      name = "IAC Device Bus 1"

      case MidiDevices.open(type, name) do
        {:ok, _device_pid} ->
          assert :ok == MidiDevices.close(type, name)

        {:error, reason} ->
          assert is_atom(reason)
      end
    end
  end

  describe "write/2" do
    test "an opened output may receive messages" do
      type = :output
      name = "IAC Device Bus 1"

      case MidiDevices.open(type, name) do
        {:ok, _device_pid} ->
          assert :ok == MidiDevices.write(type, name, {144, 60, 127})
          Process.sleep(100)
          assert :ok == MidiDevices.write(type, name, {128, 60, 0})
          Process.sleep(100)

          assert :ok ==
                   MidiDevices.write(
                     type,
                     name,
                     {{144, 60, 127}, DateTime.to_unix(DateTime.now!("UTC"))}
                   )

          Process.sleep(100)

          assert :ok ==
                   MidiDevices.write(
                     type,
                     name,
                     {{128, 60, 0}, DateTime.to_unix(DateTime.now!("UTC"))}
                   )

          Process.sleep(100)

          MidiDevices.close(type, name)

        {:error, reason} ->
          assert is_atom(reason)
      end
    end
  end
end
