# Loomer

\* This application is a work in progress. Some of the features below are not yet implemented.

Loomer allows multiple people in a phyiscal or virtual space to join a live performance.

## Requirements

For Stage Managers, PortMidi is required for musical performances. PortMidi is a system library for MacOS and Linux which can receive and broadcast MIDI events.

```bash
brew install portmidi
```

Stage Managers may use a physical MIDI device and/or a DAW like ProTools, Logic, or Reaper to receive MIDI events. If no physical device is available, a virtual device may be created in MacOS.

\* The application must be restarted in order to access newly connected or configured MIDI devices.

### Configure a Virtual MIDI Device (optional)

1. Open the **Audio MIDI Setup** app in MacOS
1. Open **Window**, then select **Show MIDI Studio** or press <kbd>CMD</kbd> + <kbd>2</kbd>
1. Below **IAC Driver**, double click the **IAC Driver** device
1. Under Ports, you may change the name of the default port or add ports. These port names are used within the application to identify devices.
1. If using a DAW, ensure the virtual device is enabled in the DAW's settings.

## Get Started

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
