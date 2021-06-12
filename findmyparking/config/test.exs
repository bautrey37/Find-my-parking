use Mix.Config

# Configure your database
config :findmyparking, Findmyparking.Repo,
  username: "postgres",
  password: "postgres",
  database: "findmyparking_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  url: "ecto://postgres:postgres@localhost/findmyparking_test"

# url: "ecto://" <> username <> ":" <> password <> "@" <> hostname <> "/" <> database

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :findmyparking, FindmyparkingWeb.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# White bread with Hound BDD testing
config :hound, driver: "chrome_driver"
config :findmyparking, sql_sandbox: true
