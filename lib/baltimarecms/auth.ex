defmodule Baltimarecms.Auth do
  alias Baltimarecms.JWT
  alias Baltimarecms.Users

  def get_user(conn) do
    case conn.req_cookies["token"] do
      nil -> nil
      token ->
        case JWT.verify_token(token) do
          {:ok, decoded} ->
            display_name = decoded["displayName"]
            # Fetch the user from the database based on displayName
            user = Users.list_users() |> Enum.find(&(&1.username == display_name))
            case user do
              nil ->
                %{display_name: display_name}
              _ ->
                %{display_name: display_name, uuid: user."UUID"}
            end
          {:error, _reason} -> nil
        end
    end
  end
end
