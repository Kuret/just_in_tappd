defmodule JustInTappdWeb.PageController do
  use JustInTappdWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
