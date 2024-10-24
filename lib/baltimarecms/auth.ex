defmodule Baltimarecms.Auth do
  alias Baltimarecms.JWT

  def get_display_name(conn) do
    case conn.req_cookies["token"] do
      nil -> nil
      token ->
        case JWT.verify_token(token) do
          {:ok, decoded} -> decoded["displayName"]
          {:error, _reason} -> nil
        end
    end
  end
end
