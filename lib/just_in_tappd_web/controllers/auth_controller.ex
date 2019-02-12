defmodule JustInTappdWeb.AuthController do
  use JustInTappdWeb, :controller

  alias JustInTappd.Accounts
  alias JustInTappd.Accounts.Session
  alias JustInTappd.Accounts.User
  alias JustInTappd.Guardian

  def login(conn, _) do
    IO.inspect(Session.current_user(conn))

    with %User{} <- Session.current_user(conn) do
      redirect(conn, to: Routes.page_path(conn, :index))
    else
      _ -> render(conn, "login.html")
    end
  end

  def authorize(conn, %{"email" => email}) do
    with %User{} = user <- Accounts.get_by_email(email),
         {:ok, _token, _claims} <- Guardian.send_magic_link(user) do
      conn
      |> put_flash(:info, "Login link sent to your e-mail address.")
      |> redirect(to: Routes.auth_path(conn, :login))
    else
      _ ->
        conn
        |> put_flash(:error, "Error logging you in.")
        |> redirect(to: Routes.auth_path(conn, :login))
    end
  end

  def callback(conn, %{"magic_token" => magic_token}) do
    case Guardian.decode_magic(magic_token) do
      {:ok, user, _claims} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, "Invalid magic link.")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def destroy(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def auth_error(conn, {:already_authenticated, _}, _opts) do
    conn
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end

  def auth_error(conn, _error, _opts) do
    conn
    |> redirect(to: Routes.auth_path(conn, :login))
    |> halt()
  end
end
