defmodule JustInTappd.Repo do
  use Ecto.Repo,
    otp_app: :just_in_tappd,
    adapter: Ecto.Adapters.Postgres
end
