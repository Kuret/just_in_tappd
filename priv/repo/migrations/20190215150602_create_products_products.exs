defmodule JustInTappd.Repo.Migrations.CreateProductsProducts do
  use Ecto.Migration

  def change do
    create table(:products_products, primary_key: false) do
      add(:id, :uuid, primary_key: true)

      add(:untappd_id, :integer)
      add(:barcode, :string)
      add(:name, :string)
      add(:producer, :string)
      add(:abv, :decimal)
      add(:price, :decimal)
      add(:stock, :integer, null: false, default: 0)

      add(:created_by_id, references(:accounts_users, type: :uuid, on_delete: :nilify_all))
      add(:updated_by_id, references(:accounts_users, type: :uuid, on_delete: :nilify_all))

      timestamps()
    end

    create(unique_index(:products_products, [:name, :barcode]))
  end
end
