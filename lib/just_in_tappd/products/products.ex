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
    %Product{}
    |> Product.update_changeset(attrs, user)
    |> Repo.insert()
  end

  @doc """
  Updates a Product
  """
  def update_product(%Product{} = product, %{} = attrs, %User{} = user) do
    product
    |> Product.update_changeset(attrs, user)
    |> Repo.update()
  end
end
