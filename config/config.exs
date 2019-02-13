# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :just_in_tappd,
  ecto_repos: [JustInTappd.Repo]

# Set the application's default locale
config :gettext, :default_locale, System.get_env("LOCALE_LANGUAGE") || "en"

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

# Guardian
config :just_in_tappd, JustInTappd.Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "JustInTappd",
  ttl: {30, :days},
  token_ttl: %{
    "magic" => {30, :minutes},
    "access" => {1, :days}
  },
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: System.get_env("SECRET_KEY_BASE") || "1234",
  serializer: JustInTappd.Guardian

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_tappd,
  api_user: System.get_env("UT_USER"),
  rw_api_key: System.get_env("UT_RW_KEY"),
  ro_api_key: System.get_env("UT_RO_KEY"),
  base_url: System.get_env("UT_BASE_URL") || "https://business.untappd.com/api/v1"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
