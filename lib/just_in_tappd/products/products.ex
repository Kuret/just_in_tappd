defmodule JustInTappd.Products do
  @moduledoc """
  Interface for Products.
  """

  import Ecto.Query

  alias JustInTappd.Accounts.User
  alias JustInTappd.Products.Product
  alias JustInTappd.Repo

  @doc """
  Lists Products by stock status
  """
  def list_products(in_stock \\ true) do
    Product
    |> filter_on_stock(in_stock)
    |> Repo.all()
  end

  defp filter_on_stock(query, true), do: where(query, [p], p.stock > 0)
  defp filter_on_stock(query, _), do: where(query, [p], p.stock <= 0)

  @doc """
  Lists all Products
  """
  def list_all_products, do: Repo.all(Product)

  @doc """
  Gets a product
  TODO: Also retrieve UT data
  """
  def get_product(id), do: Repo.get!(Product, id)

  @doc """
  Creates a Product
  """
  def create_product(%{} = attrs, %User{} = user) do
    with %Product{} = product <- get_duplicate(attrs) do
      new_stock =
        with stock <- attrs["stock"],
             true <- is_binary(stock),
             {num, _} <- Integer.parse(stock) do
          num + (product.stock || 0)
        else
          _ -> product.stock
        end

      update_product(
        product,
        %{
          stock: new_stock,
          price: attrs["price"] || product.price,
          barcode: attrs["barcode"] || product.barcode,
          abv: attrs["abv"] || product.abv
        },
        user
      )
    else
      _ ->
        %Product{}
        |> Product.update_changeset(attrs, user)
        |> Repo.insert()
    end
  end

  defp get_duplicate(%{"untappd_id" => untappd_id, "name" => name}),
    do: Repo.get_by(Product, untappd_id: untappd_id, name: name)

  defp get_duplicate(_), do: nil

  @doc """
  Updates a Product
  """
  def update_product(%Product{} = product, %{} = attrs, %User{} = user) do
    product
    |> Product.update_changeset(attrs, user)
    |> Repo.update()
  end
end
