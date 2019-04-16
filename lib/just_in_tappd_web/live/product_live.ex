defmodule JustInTappdWeb.ProductLive do
  use Phoenix.LiveView

  alias ExTappd.Item
  alias JustInTappd.Accounts.User
  alias JustInTappd.Products
  alias JustInTappd.Products.Product
  alias JustInTappdWeb.ProductView

  def render(assigns) do
    ProductView.render("new.html", assigns)
  end

  def mount(session, socket) do
    if connected?(socket), do: Process.send_after(self(), :check_barcode, 1000)
    :ets.delete(:barcodes, :active)

    {:ok, assign(socket, session)}
  end

  def handle_info(:check_barcode, socket) do
    Process.send_after(self(), :check_barcode, 1000)

    with [active: barcode] <- :ets.lookup(:barcodes, :active) do
      {:noreply, assign(socket, barcode: barcode)}
    else
      _ -> {:noreply, socket}
    end
  end

  def handle_event("suggest", %{"product" => %{"name" => query}}, socket)
      when byte_size(query) >= 4 and byte_size(query) <= 100,
      do: return_items(socket, query)

  def handle_event("suggest", _, socket), do: {:noreply, socket}

  def handle_event(
        "create",
        %{"product" => attrs},
        %{assigns: %{added: added, user: %User{} = user}} = socket
      ) do
    case Products.create_product(attrs, user) do
      {:ok, %Product{} = product} ->
        {:noreply, assign(socket, fill: %{}, stock: nil, barcode: nil, added: added ++ [product])}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("stock" <> num, _, socket) do
    with {int, _} <- Integer.parse(num) do
      {:noreply, assign(socket, stock: int)}
    else
      _ -> {:noreply, socket}
    end
  end

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
