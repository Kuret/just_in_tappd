defmodule JustInTappdWeb.Router do
  use JustInTappdWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated do
    plug Guardian.Plug.Pipeline,
      otp_app: :just_in_tappd,
      module: JustInTappd.Guardian,
      error_handler: JustInTappdWeb.AuthController

    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource, ensure: true
  end

  pipeline :unauthenticated do
    plug Guardian.Plug.Pipeline,
      otp_app: :just_in_tappd,
      module: JustInTappd.Guardian,
      error_handler: JustInTappdWeb.AuthController

    plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
    plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
    plug(Guardian.Plug.EnsureNotAuthenticated)
  end

  pipeline :api do
    plug BasicAuth, use_config: {:just_in_tappd, :basic_auth}
    plug :accepts, ["json"]
  end

  scope "/", JustInTappdWeb do
    pipe_through [:browser, :authenticated]

    get "/", PageController, :index
    get "/search", SearchController, :index
    post "/search/:id", SearchController, :create

    resources("/products", ProductController)
    post("/products/new", ProductController, :new)

    get "/logout", AuthController, :destroy
  end

  scope "/login", JustInTappdWeb do
    pipe_through [:browser, :unauthenticated]

    get "/", AuthController, :login
    post "/", AuthController, :authorize
    get "/:magic_token", AuthController, :callback
  end

  scope "/scan", JustInTappdWeb do
    pipe_through :api

    get "/:barcode", BarcodeController, :create
  end
end
