defmodule JustInTappd.Repo.Migrations.CreateAccountsUsers do
  use Ecto.Migration

  def change do
    create table(:accounts_users, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :active, :boolean, default: true

      timestamps()
    end

    create unique_index(:accounts_users, [:email])
    create index(:accounts_users, :active)
  end
end
