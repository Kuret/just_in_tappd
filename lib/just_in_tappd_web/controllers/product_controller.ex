defmodule JustInTappdWeb.ProductController do
  use JustInTappdWeb, :controller

  alias Ecto.Changeset

  alias JustInTappd.Accounts.Session
  alias JustInTappd.Products
  alias JustInTappd.Products.Product

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
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"product" => attrs}) do
    user = Session.current_user(conn)

    case Products.create_product(attrs, user) do
      {:ok, %Product{}} ->
        conn
        |> put_flash(:info, gettext("Added beer to inventory"))
        |> redirect(to: Routes.product_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("new.html", changeset: changeset)

      error ->
        error
    end
  end
end
