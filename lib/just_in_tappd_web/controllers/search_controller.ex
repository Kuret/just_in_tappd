defmodule JustInTappdWeb.SearchController do
  use JustInTappdWeb, :controller

  alias ExTappd.Item

  def index(conn, %{"query" => query}) do
    with {:ok, items} <- Item.search_item(query) do
      render(conn, "index.html", items: items)
    else
      _ -> render(conn, "index.html")
    end
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"id" => id}) do
    with {:ok, _items} <- Item.add_item(id, "350941") do
      conn
      |> put_flash(:info, "Successfully added beer to menu!")
      |> redirect(to: Routes.search_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:error, "Error adding beer to menu")
        |> redirect(to: Routes.search_path(conn, :index))
    end
  end
end
