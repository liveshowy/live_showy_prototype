import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :loom, LoomWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "AL4mDMM5XWM3XMgWjaNt2NKhwydu/zLUJ6h9RXR1i0gaFOyr+tDQs1uvudczfHrd",
  server: false

# In test we don't send emails.
config :loom, Loom.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
