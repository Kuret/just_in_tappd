defmodule JustInTappdWeb.ProductController do
  use JustInTappdWeb, :controller

  alias Ecto.Changeset
  alias JustInTappd.Accounts.Session
  alias JustInTappd.Products
  alias JustInTappd.Products.Product
  alias JustInTappdWeb.ProductLive

  def index(conn, %{"stock" => "all"}) do
    with [_ | _] = products <- Products.list_all_products() do
      render(conn, "index.html", products: products)
    end
  end

  def index(conn, %{"stock" => "no"}) do
    with [_ | _] = products <- Products.list_products(false) do
      render(conn, "index.html", products: products)
    end
  end

  def index(conn, _attrs) do
    with [_ | _] = products <- Products.list_products() do
      render(conn, "index.html", products: products)
    end
  end

  def new(conn, attrs \\ %{}) do
    user = Session.current_user(conn)

    with %Changeset{} = changeset <- Product.create_changeset(attrs, user) do
      render_new(conn, changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Session.current_user(conn)

    with %Product{} = product <- Products.get_product(id),
         %Changeset{} = changeset <- Product.update_changeset(product, %{}, user) do
      render_edit(conn, changeset, product)
    end
  end

  defp render_new(conn, changeset) do
    render_form(conn, changeset, gettext("Add Product"), :create)
  end

  defp render_edit(conn, changeset, product) do
    render_form(
      conn,
      changeset,
      gettext("Update Product"),
      :update,
      %{
        name: product.name,
        brewery: product.producer,
        abv: product.abv,
        untappd_id: product.untappd_id
      }
    )
  end

  defp render_form(conn, changeset, title, submit, fill \\ %{}) do
    live_render(conn, ProductLive,
      session: %{
        added: [],
        user: Session.current_user(conn),
        fill: fill,
        items: [],
        changeset: changeset,
        title: title,
        submit: submit
      }
    )
  end
end
