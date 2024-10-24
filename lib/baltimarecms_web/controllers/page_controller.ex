defmodule BaltimarecmsWeb.PageController do
  use BaltimarecmsWeb, :controller
  alias Baltimarecms.Auth

  def home(conn, _params) do
    displayName = Auth.get_display_name(conn) # Use the function

    render(conn, :home, displayName: displayName)
  end
end
