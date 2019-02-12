defmodule JustInTappd.Accounts.Session do
  @moduledoc """
  Interface for all things Session
  """

  alias Guardian.Plug

  @doc """
  Get the current user.
  """
  def current_user(conn), do: get_current_user(conn)

  # Get the current user resource.
  defp get_current_user(conn) do
    Plug.current_resource(conn)
  end
end
