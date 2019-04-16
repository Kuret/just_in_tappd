defmodule JustInTappdWeb.BarcodeController do
  use JustInTappdWeb, :controller

  def create(conn, %{"barcode" => code}) when is_binary(code) do
    :ets.insert(:barcodes, {:active, code})

    json(conn, :ok)
  end

  def create(conn, opts), do: IO.inspect(opts) && conn
end
