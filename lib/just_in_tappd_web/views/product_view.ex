defmodule JustInTappdWeb.ProductView do
  use JustInTappdWeb, :view

  def untappd_image_url(untappd_id), do: "https://labels.untappd.com/labels/#{untappd_id}"
end
