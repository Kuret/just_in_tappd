# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :just_in_tappd,
  ecto_repos: [JustInTappd.Repo]

# Configures the endpoint
config :just_in_tappd, JustInTappdWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bUqz8DzRc2P3X18HfbqbMwMOsLyqNYDBu2ovKL2sr05R/YtKgvxyXtyheqEqmKav",
  render_errors: [view: JustInTappdWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: JustInTappd.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
