import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :async_tasks, AsyncTasks.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "async_tasks_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :async_tasks, AsyncTasksWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "3v5MHdSbAdvD8ObSFozD3J7qy998PX/lKJ66+mGGbbJZZU0cTqDQIdQiH3LyAyFN",
  server: false

# In test we don't send emails.
config :async_tasks, AsyncTasks.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
