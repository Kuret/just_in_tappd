use Mix.Config

defmodule Prod.Config do
  def host, do: hosts() |> List.first()
  def hosts, do: [host_url(), heroku_app_url()] |> Enum.reject(&is_nil/1)
  def origins, do: hosts() |> Enum.map(&("https://" <> &1))

  defp host_url, do: System.get_env("HOST_URL")

  defp heroku_app_url do
    case System.get_env("HEROKU_APP_NAME") do
      nil -> nil
      "" -> nil
      app_name -> app_name <> ".herokuapp.com"
    end
  end
end

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :just_in_tappd, JustInTappdWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_origin: Prod.Config.origins(),
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  load_from_system_env: true,
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  url: [scheme: "https", host: Prod.Config.host(), port: 443]

# Do not print debug messages in production
config :logger, level: :info

config :just_in_tappd, JustInTapp.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :just_in_tappd, JustInTappdWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         :inet6,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :just_in_tappd, JustInTappdWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases (distillery)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :just_in_tappd, JustInTappdWeb.Endpoint, server: true
#
# Note you can't rely on `System.get_env/1` when using releases.
# See the releases documentation accordingly.

# Finally import the config/prod.secret.exs which should be versioned
# separately.
