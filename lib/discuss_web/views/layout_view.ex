defmodule DiscussWeb.LayoutView do
  use DiscussWeb, :view

  def display_auth_button(conn) do
    Map.get(conn.assigns, :user)
    |> render_button(conn)
  end

  defp render_button(nil, conn) do
    link("Sign in with Github", to: auth_path(conn, :request, "github"))
  end

  defp render_button(_user, conn) do
    link("Sign Out", to: auth_path(conn, :signout, []))
  end
end
