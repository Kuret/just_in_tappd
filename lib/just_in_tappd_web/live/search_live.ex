defmodule JustInTappdWeb.SearchLive do
  use Phoenix.LiveView

  alias JustInTappdWeb.SearchView
  alias ExTappd.Item

  def render(assigns) do
    SearchView.render("index.html", assigns)
  end

  def mount(%{query: query, csrf_token: csrf_token}, socket) do
    items = with {:ok, items} <- Item.search_item(query), do: items, else: (_ -> [])

    {:ok, assign(socket, csrf_token: csrf_token, items: items, query: query)}
  end

  def handle_event("suggest", %{"query" => query}, socket)
      when byte_size(query) <= 100,
      do: return_items(socket, query)

  def handle_event("suggest", query, socket) when byte_size(query) <= 100,
    do: return_items(socket, query)

  defp return_items(socket, query) do
    items = with {:ok, items} <- Item.search_item(query), do: items, else: (_ -> [])

    {:noreply, assign(socket, items: items)}
  end
end
