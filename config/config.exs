# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :id_screw,
  ecto_repos: [IdScrew.Repo]

# Configures the endpoint
config :id_screw, IdScrewWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bpIrTPaJKacKRNcX3r+p72CZNZm4qdEvqkYS1bH/vilQa3qOlJsWs0fdpmK+TJ4w",
  render_errors: [view: IdScrewWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: IdScrew.PubSub,
  live_view: [signing_salt: "pZl35XEo"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
