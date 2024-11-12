defmodule BaltimarecmsWeb.PageController do
  use BaltimarecmsWeb, :controller

  def home(conn, _params) do
    current_user = conn.assigns.current_user

    render(conn, :home, display_name: current_user)
  end
end
