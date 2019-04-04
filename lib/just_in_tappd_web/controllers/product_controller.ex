defmodule JustInTappdWeb.ProductController do
  use JustInTappdWeb, :controller

  alias JustInTappd.Accounts.Session
  alias JustInTappd.Accounts.User
  alias JustInTappd.Products.Product

  def new(conn, _) do
    %User{} = user = Session.current_user(conn)

    with changeset <- Product.create_changeset(%{}, user) do
      render(conn, "new.html", changeset: changeset)
    end
  end
end
