defmodule JustInTappdWeb.ProductLive do
  use Phoenix.LiveView

  alias ExTappd.Item
  alias JustInTappdWeb.ProductView

  def render(assigns) do
    ProductView.render("new.html", assigns)
  end

  def mount(session, socket) do
    {:ok, assign(socket, session)}
  end

  def handle_event("suggest", %{"name_field" => query}, socket)
      when byte_size(query) <= 100,
      do: return_items(socket, query)

  def handle_event("suggest", _, socket), do: {:noreply, socket}

  def handle_event("fill" <> index, _, socket) do
    with {int, _} <- Integer.parse(index),
         %{assigns: %{items: [_ | _] = items}} <- socket,
         %Item{} = item <- Enum.at(items, int) do
      {:noreply, assign(socket, fill: Map.from_struct(item))}
    else
      _ -> {:noreply, socket}
    end
  end

  defp return_items(socket, query) do
    items = with {:ok, items} <- Item.search_item(query), do: items, else: (_ -> [])

    {:noreply, assign(socket, items: items)}
  end
end
