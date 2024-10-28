defmodule BaltimarecmsWeb.BanController do
  use BaltimarecmsWeb, :controller

  alias Baltimarecms.Bans
  alias Baltimarecms.Bans.Ban
  alias Baltimarecms.DateUtils
  alias Baltimarecms.Auth

  def index(conn, _params) do
    bans = Bans.list_bans()
    render(conn, :index, bans: bans)
  end

  def new(conn, _params) do
    changeset = Bans.change_ban(%Ban{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"ban" => ban_params}) do
    user = Auth.get_user(conn)

    updated_ban_params =
      Map.put(ban_params, "time", DateUtils.current_time_unix())
      |> Map.put("janny", user.display_name)
      # |> Map.put("until", 0)

    IO.inspect(updated_ban_params)

    case Bans.create_ban(updated_ban_params) do
      {:ok, ban} ->
        conn
        |> put_flash(:info, "Ban created successfully.")
        |> redirect(to: ~p"/bans/#{ban}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    ban = Bans.get_ban!(id)
    render(conn, :show, ban: ban)
  end

  def edit(conn, %{"id" => id}) do
    ban = Bans.get_ban!(id)
    changeset = Bans.change_ban(ban)
    render(conn, :edit, ban: ban, changeset: changeset)
  end

  def update(conn, %{"id" => id, "ban" => ban_params}) do
    ban = Bans.get_ban!(id)
    user = Auth.get_user(conn)

    updated_ban_params =
      Map.put(ban_params, "time", DateUtils.current_time_unix())
      |> Map.put("janny", user.display_name)
      |> Map.put("until", 0)

    case Bans.update_ban(ban, updated_ban_params) do
      {:ok, ban} ->
        conn
        |> put_flash(:info, "Ban updated successfully.")
        |> redirect(to: ~p"/bans/#{ban}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, ban: ban, changeset: changeset)
    end
  end

  # def delete(conn, %{"id" => id}) do
  #   ban = Bans.get_ban!(id)
  #   {:ok, _ban} = Bans.delete_ban(ban)

  #   conn
  #   |> put_flash(:info, "Ban deleted successfully.")
  #   |> redirect(to: ~p"/bans")
  # end
end
