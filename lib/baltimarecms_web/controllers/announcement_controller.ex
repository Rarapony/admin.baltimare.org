defmodule BaltimarecmsWeb.AnnouncementController do
  use BaltimarecmsWeb, :controller

  alias Baltimarecms.Announcements
  alias Baltimarecms.Announcements.Announcement

  def index(conn, _params) do
    announcements = Announcements.list_announcements()
    render(conn, :index, announcements: announcements)
  end

  def new(conn, _params) do
    changeset = Announcements.change_announcement(%Announcement{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"announcement" => announcement_params}) do

    user = conn.assigns.current_user

    updated_announcement_params =
      Map.put(announcement_params, "announcer", user.username)

      case Announcements.create_announcement(updated_announcement_params) do
        {:ok, announcement} ->
          conn
          |> put_flash(:info, "Announcement created successfully.")
          |> redirect(to: ~p"/announcements/#{announcement}")

          {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    announcement = Announcements.get_announcement!(id)
    render(conn, :show, announcement: announcement)
  end

  def edit(conn, %{"id" => id}) do
    announcement = Announcements.get_announcement!(id)
    changeset = Announcements.change_announcement(announcement)
    render(conn, :edit, announcement: announcement, changeset: changeset)
  end

  def update(conn, %{"id" => id, "announcement" => announcement_params}) do
    announcement = Announcements.get_announcement!(id)

    user = conn.assigns.current_user

    updated_announcement_params =
      Map.put(announcement_params, "announcer", user.username)

    case Announcements.update_announcement(announcement, updated_announcement_params) do
      {:ok, announcement} ->
        conn
        |> put_flash(:info, "Announcement updated successfully.")
        |> redirect(to: ~p"/announcements/#{announcement}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, announcement: announcement, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    announcement = Announcements.get_announcement!(id)
    {:ok, _announcement} = Announcements.delete_announcement(announcement)

    conn
    |> put_flash(:info, "Announcement deleted successfully.")
    |> redirect(to: ~p"/announcements")
  end
end
