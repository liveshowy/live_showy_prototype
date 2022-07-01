[![Elixir CI](https://github.com/type1fool/live_showy/actions/workflows/elixir.yml/badge.svg?branch=main)](https://github.com/type1fool/live_showy/actions/workflows/elixir.yml)

# LiveShowy Prototype

\* This repo is an archive of the prototype demonstrated at The Big Elixir 2022 in New Orleans. The application, LiveShowy, is a proof of concept for allowing several people to play music together in realtime on a local network.

The repo is publicly visible so that inquiring Elixirists may review its code for inspiration and discussion about the next version of the app, which will be geared toward web-based music collaboration.

Feel free to clone the repo, tinker, and [discuss](https://github.com/liveshowy/live_showy_prototype/discussions). Not sure where to start? The [`Users`](lib/live_showy/users.ex) module may be interesting.

**CAUTION**

This application is not intended to be deployed in a typical web environment, and has been operated in a live environment only once. Documentation is minimal, and implimentations in the source code may not be sufficiently robust for your application. This code is offered with no warranty.

## A Proscenium-Level View

The LiveShowy prototype was designed and developed in the lead up to The Big Elixir 2022, where I gave a talk about doing fun and novel stuff with Phoenix LiveView. The dependencies for this app are minimal (1 JS pkg, 21 Hex pkgs), including no external database dependency; ETS is used for local-only persistence in this version of LiveShowy.

## Roles

LiveShowy uses four pre-defined, primitive roles to allow access to areas of the UI.

| Role                | Abilities                       |
| ------------------- | ------------------------------- |
| Attendee            | May access the landing page     |
| Backstage Performer | May access the backstage        |
| Mainstage Performer | May access the mainstage        |
| Stage Manager       | May assign roles to other users |

## Areas

LiveShowy has four areas where users may be directed.

| Area                                                            | Description                                                                                     |
| --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| [LandingLive](lib/live_showy_web/live/landing_live/)            | The first view a user sees. Contains general information.                                       |
| [BackstageLive](lib/live_showy_web/live/backstage_live/)        | A user may prepare for a performance by connecting a MIDI device or using the on-page keyboard. |
| [MainstageLive](lib/live_showy_web/live/stage_live/)            | A user may perform music through the host machine's DAW.                                        |
| [StageManagerLive](lib/live_showy_web/live/stage_manager_live/) | A stage manager may grant and revoke roles, and communicate with performers.                    |

An `attendee` who is viewing the landing page will be automatically redirected to the backstage immediately after receiving a `backstage performer` role. In the backstage, a link to the mainstage will appear immediately after the user receives a `mainstage performer` role. These redirects and magically-appearing links are backed by Phoenix PubSub.

In backstage, mainstage, and stage manager live views, a chat panel is rendered to allow users to communicate in realtime - hypothetically about an ongoing performance, possibly about what's for dinner.

## Requirements

You may install system dependencies using [ASDF](https://asdf-vm.com/).

```bash
asdf install
```

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
