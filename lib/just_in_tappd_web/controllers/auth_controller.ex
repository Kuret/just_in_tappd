defmodule JustInTappdWeb.AuthController do
  use JustInTappdWeb, :controller

  alias JustInTappd.Accounts
  alias JustInTappd.Guardian

  def new(_conn, %{"email" => email}) do
    user = Accounts.get_by_email(email)
    Guardian.send_magic_link(user)
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

  def auth_error(conn, _error, _opts) do
    conn
    |> put_flash(:error, "Authentication error.")
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end
end
