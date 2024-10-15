defmodule BaltimarecmsWeb.AnnouncementControllerTest do
  use BaltimarecmsWeb.ConnCase

  import Baltimarecms.AnnouncementsFixtures

  @create_attrs %{title: "some title", content: "some content", announcer: "some announcer"}
  @update_attrs %{title: "some updated title", content: "some updated content", announcer: "some updated announcer"}
  @invalid_attrs %{title: nil, content: nil, announcer: nil}

  describe "index" do
    test "lists all announcements", %{conn: conn} do
      conn = get(conn, ~p"/announcements")
      assert html_response(conn, 200) =~ "Listing Announcements"
    end
  end

  describe "new announcement" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/announcements/new")
      assert html_response(conn, 200) =~ "New Announcement"
    end
  end

  describe "create announcement" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/announcements", announcement: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/announcements/#{id}"

      conn = get(conn, ~p"/announcements/#{id}")
      assert html_response(conn, 200) =~ "Announcement #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/announcements", announcement: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Announcement"
    end
  end

  describe "edit announcement" do
    setup [:create_announcement]

    test "renders form for editing chosen announcement", %{conn: conn, announcement: announcement} do
      conn = get(conn, ~p"/announcements/#{announcement}/edit")
      assert html_response(conn, 200) =~ "Edit Announcement"
    end
  end

  describe "update announcement" do
    setup [:create_announcement]

    test "redirects when data is valid", %{conn: conn, announcement: announcement} do
      conn = put(conn, ~p"/announcements/#{announcement}", announcement: @update_attrs)
      assert redirected_to(conn) == ~p"/announcements/#{announcement}"

      conn = get(conn, ~p"/announcements/#{announcement}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, announcement: announcement} do
      conn = put(conn, ~p"/announcements/#{announcement}", announcement: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Announcement"
    end
  end

  describe "delete announcement" do
    setup [:create_announcement]

    test "deletes chosen announcement", %{conn: conn, announcement: announcement} do
      conn = delete(conn, ~p"/announcements/#{announcement}")
      assert redirected_to(conn) == ~p"/announcements"

      assert_error_sent 404, fn ->
        get(conn, ~p"/announcements/#{announcement}")
      end
    end
  end

  defp create_announcement(_) do
    announcement = announcement_fixture()
    %{announcement: announcement}
  end
end
