# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :findmyparking,
  ecto_repos: [Findmyparking.Repo]

# Configures the endpoint
config :findmyparking, FindmyparkingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "y5Lhs9OHtgIhXY8jzEOIpiG6E7Cdz6G7lXHhgU50n43XxAEmOy66NgqIer+vYQnv",
  render_errors: [view: FindmyparkingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Findmyparking.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :findmyparking, Findmyparking.Guardian,
  issuer: "findmyparking",
  secret_key: "ly1AwJLetM/z018UGJdBJouWWe7Sc5HE38kR1kb6Q0Zd2T5lk/LxDyhUoekJ7SrS"
