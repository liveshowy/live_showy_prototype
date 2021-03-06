# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :live_showy, env: config_env()

config :live_showy,
  initial_roles: [
    :attendee,
    :backstage_performer,
    :mainstage_performer,
    :stage_manager
  ],
  wifi: [
    ssid: "LiveShowy",
    password: "live-showy-rocks!",
    url: "liveshowy.local"
  ]

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :tailwind,
  version: "3.0.15",
  default: [
    cd: Path.expand("../assets", __DIR__),
    args: ~w(
      --config=./tailwind.config.js
      --input=./css/app.css
      --output=../priv/static/assets/app.css
    )
  ]

# Configures the endpoint
config :live_showy, LiveShowyWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: LiveShowyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveShowy.PubSub,
  live_view: [signing_salt: "Cyk3GV4m"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :live_showy, LiveShowy.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.13.4",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :plug_cowboy,
  log_exceptions_with_status_code: [400..599]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :surface, :components, [
  {Surface.Components.Form.ErrorTag,
   default_translator: {LiveShowyWeb.ErrorHelpers, :translate_error}}
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
