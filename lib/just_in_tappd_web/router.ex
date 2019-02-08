defmodule JustInTappdWeb.Router do
  use JustInTappdWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JustInTappdWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/search", SearchController, :index
    post "/search/:id", SearchController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", JustInTappdWeb do
  #   pipe_through :api
  # end
end
