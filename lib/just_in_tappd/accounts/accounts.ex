defmodule JustInTappd.Accounts do
  @moduledoc """
  The Accounts interface
  """

  import Ecto.Query, warn: false

  alias JustInTappd.Accounts.User
  alias JustInTappd.Repo

  def list_users(active \\ true) do
    User
    |> where(active: ^active)
    |> Repo.all()
  end

  def get_user(id), do: Repo.get(User, id)

  def get_by_email(email), do: Repo.get_by(User, email: email)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_user(attrs \\ %{}) do
    User.changeset(%User{}, attrs)
  end
end
