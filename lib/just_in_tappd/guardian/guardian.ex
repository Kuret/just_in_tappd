defmodule JustInTappd.Guardian do
  @moduledoc """
  Application specific implementation of guardian 1.0

  This contains the (token-)serializers
  """
  use Guardian, otp_app: :just_in_tappd
  use SansPassword

  alias Ecto.UUID
  alias JustInTappd.Accounts
  alias JustInTappd.Accounts.User

  # Serialize user
  def subject_for_token(%User{id: user_id}, _claims) when not is_nil(user_id),
    do: {:ok, "User:" <> user_id}

  def subject_for_token(_, _), do: {:error, "Unknown resource type"}

  # Deserialize user
  def resource_from_claims(%{"sub" => "User:" <> id}) do
    with {:ok, id} <- UUID.cast(id) do
      {:ok, Accounts.get_user(id)}
    else
      :error -> {:error, :invalid_id}
    end
  rescue
    Ecto.NoResultsError -> {:error, :no_result}
  end

  def resource_from_claims(_claims), do: {:error, "Unknown resource type"}

  def deliver_magic_link(_user, magic_token, _opts) do
    require Logger

    import JustInTappdWeb.Router.Helpers

    alias JustInTappdWeb.Endpoint

    if Mix.env() in [:dev, :test] do
      Logger.info("""
        AUTH URL: #{auth_url(Endpoint, :callback, magic_token)}
      """)
    end
  end
end
