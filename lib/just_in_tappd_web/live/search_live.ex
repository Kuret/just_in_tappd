defmodule JustInTappdWeb.SearchLive do
  use Phoenix.LiveView

  alias JustInTappdWeb.SearchView
  alias ExTappd.Item

  def render(assigns) do
    SearchView.render("index.html", assigns)
  end

  def mount(%{query: query, csrf_token: csrf_token}, socket) do
    items = with {:ok, items} <- Item.search_item(query), do: items, else: (_ -> [])
    do_mount(socket, query: query, items: items, csrf_token: csrf_token)
  end

  def mount(_, socket), do: do_mount(socket)

  defp do_mount(socket, opts \\ []) do
    {:ok,
     assign(socket,
       csrf_token: opts[:csrf_token],
       items: opts[:items],
       query: opts[:query],
       result: nil,
       loading: false
     )}
  end

  def handle_event("suggest", query, socket) when byte_size(query) <= 100 do
    items = with {:ok, items} <- Item.search_item(query), do: items, else: (_ -> [])

    {:noreply, assign(socket, items: items, query: query)}
  end

  def handle_event("suggest", %{"query" => query}, socket) when byte_size(query) <= 100 do
    items = with {:ok, items} <- Item.search_item(query), do: items, else: (_ -> [])

    {:noreply, assign(socket, items: items, query: query)}
  end
end
