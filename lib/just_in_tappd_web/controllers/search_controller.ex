defmodule JustInTappdWeb.SearchController do
  use JustInTappdWeb, :controller

  alias ExTappd.Item
  alias JustInTappdWeb.SearchLive

  def index(conn, params) do
    live_render(conn, SearchLive,
      session: %{csrf_token: Phoenix.Controller.get_csrf_token(), query: params["query"]}
    )
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
