defmodule JustInTappd.Accounts.User do
  @moduledoc """
  Schema for the User
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias JustInTappd.Accounts
  alias JustInTappd.Accounts.User
  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "accounts_users" do
    field(:email, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:active, :boolean, default: true)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs, opts \\ %{}) do
    user
    |> cast(attrs, [
      :email,
      :first_name,
      :last_name,
      :active
    ])
    |> validate_required([:email, :active])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
  end
end
