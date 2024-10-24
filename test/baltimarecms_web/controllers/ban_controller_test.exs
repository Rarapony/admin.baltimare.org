defmodule BaltimarecmsWeb.BanControllerTest do
  use BaltimarecmsWeb.ConnCase

  import Baltimarecms.BansFixtures

  @create_attrs %{active: true, reason: "some reason", time: 42, until: 42, uuid: "some uuid", janny: "some janny", rule: 42}
  @update_attrs %{active: false, reason: "some updated reason", time: 43, until: 43, uuid: "some updated uuid", janny: "some updated janny", rule: 43}
  @invalid_attrs %{active: nil, reason: nil, time: nil, until: nil, uuid: nil, janny: nil, rule: nil}

  describe "index" do
    test "lists all bans", %{conn: conn} do
      conn = get(conn, ~p"/bans")
      assert html_response(conn, 200) =~ "Listing Bans"
    end
  end

  describe "new ban" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/bans/new")
      assert html_response(conn, 200) =~ "New Ban"
    end
  end

  describe "create ban" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/bans", ban: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/bans/#{id}"

      conn = get(conn, ~p"/bans/#{id}")
      assert html_response(conn, 200) =~ "Ban #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/bans", ban: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Ban"
    end
  end

  describe "edit ban" do
    setup [:create_ban]

    test "renders form for editing chosen ban", %{conn: conn, ban: ban} do
      conn = get(conn, ~p"/bans/#{ban}/edit")
      assert html_response(conn, 200) =~ "Edit Ban"
    end
  end

  describe "update ban" do
    setup [:create_ban]

    test "redirects when data is valid", %{conn: conn, ban: ban} do
      conn = put(conn, ~p"/bans/#{ban}", ban: @update_attrs)
      assert redirected_to(conn) == ~p"/bans/#{ban}"

      conn = get(conn, ~p"/bans/#{ban}")
      assert html_response(conn, 200) =~ "some updated reason"
    end

    test "renders errors when data is invalid", %{conn: conn, ban: ban} do
      conn = put(conn, ~p"/bans/#{ban}", ban: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Ban"
    end
  end

  describe "delete ban" do
    setup [:create_ban]

    test "deletes chosen ban", %{conn: conn, ban: ban} do
      conn = delete(conn, ~p"/bans/#{ban}")
      assert redirected_to(conn) == ~p"/bans"

      assert_error_sent 404, fn ->
        get(conn, ~p"/bans/#{ban}")
      end
    end
  end

  defp create_ban(_) do
    ban = ban_fixture()
    %{ban: ban}
  end
end
