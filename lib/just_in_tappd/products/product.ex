defmodule JustInTappd.Products.Product do
  @moduledoc """
  Schema for Products
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias JustInTappd.Accounts.User
  alias JustInTappd.Products.Product

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "products_products" do
    field(:untappd_id, :integer)
    field(:barcode, :string)
    field(:name, :string)
    field(:producer, :string)
    field(:abv, :decimal)
    field(:expiration_date, :naive_datetime, default: nil)
    field(:price, :decimal)
    field(:stock, :integer, default: 0)

    belongs_to(:created_by, User, type: :binary_id)
    belongs_to(:updated_by, User, type: :binary_id)

    timestamps()

    # TODO: Add Later
    # field(:size, :binary_id)
    # field(:supplier_id, :binary_id)
  end

  @doc false
  def create_changeset(%{} = attrs, %User{} = user) do
    %Product{}
    |> cast(attrs, [
      :untappd_id,
      :barcode,
      :name,
      :producer,
      :abv,
      :expiration_date,
      :price,
      :stock
    ])
    |> put_change(:created_by_id, user.id)
    |> validate_required([:name, :producer, :price])
    |> unique_constraint(:name)
    |> unique_constraint(:barcode)
  end

  @doc false
  def update_changeset(%Product{} = product, %{} = attrs, %User{} = user) do
    product
    |> cast(attrs, [
      :untappd_id,
      :barcode,
      :name,
      :producer,
      :abv,
      :expiration_date,
      :price,
      :stock
    ])
    |> put_change(:updated_by_id, user.id)
    |> validate_required([:name, :producer, :price])
    |> unique_constraint(:name)
    |> unique_constraint(:barcode)
  end
end
