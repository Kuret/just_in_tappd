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
      render(conn, "new.html",
        changeset: changeset,
        title: gettext("Add Product"),
        submit_path: Routes.product_path(conn, :create)
      )
    end
  end

  def create(conn, %{"product" => attrs}) do
    user = Session.current_user(conn)

    case Products.create_product(attrs, user) do
      {:ok, %Product{}} ->
        conn
        |> put_flash(:info, gettext("Added beer to inventory"))
        |> redirect(to: Routes.product_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("new.html",
          changeset: changeset,
          title: gettext("Add Product"),
          submit_path: Routes.product_path(conn, :create)
        )

      error ->
        error
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Session.current_user(conn)

    with %Product{} = product <- Products.get_product(id),
         %Changeset{} = changeset <- Product.update_changeset(product, %{}, user) do
      render(conn, "new.html",
        changeset: changeset,
        title: gettext("Update Product"),
        submit_path: Routes.product_path(conn, :update, product)
      )
    end
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    user = Session.current_user(conn)

    with %Product{} = product <- Products.get_product(id) do
      case Products.update_product(product, product_params, user) do
        {:ok, %Product{}} ->
          conn
          |> put_flash(:info, gettext("Updated beer details"))
          |> redirect(to: Routes.product_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> render("new.html",
            changeset: changeset,
            title: gettext("Update Product"),
            submit_path: Routes.product_path(conn, :update, product)
          )

        error ->
          error
      end
    end
  end
end
