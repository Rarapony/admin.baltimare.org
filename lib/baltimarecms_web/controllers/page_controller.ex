defmodule BaltimarecmsWeb.PageController do
  use BaltimarecmsWeb, :controller
  alias Baltimarecms.Auth

  def home(conn, _params) do
    user = Auth.get_user(conn)

    render(conn, :home, displayName: user.display_name)
  end
end
