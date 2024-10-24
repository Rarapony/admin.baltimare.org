defmodule Baltimarecms.BansTest do
  use Baltimarecms.DataCase

  alias Baltimarecms.Bans

  describe "bans" do
    alias Baltimarecms.Bans.Ban

    import Baltimarecms.BansFixtures

    @invalid_attrs %{active: nil, reason: nil, time: nil, until: nil, uuid: nil, janny: nil, rule: nil}

    test "list_bans/0 returns all bans" do
      ban = ban_fixture()
      assert Bans.list_bans() == [ban]
    end

    test "get_ban!/1 returns the ban with given id" do
      ban = ban_fixture()
      assert Bans.get_ban!(ban.id) == ban
    end

    test "create_ban/1 with valid data creates a ban" do
      valid_attrs = %{active: true, reason: "some reason", time: 42, until: 42, uuid: "some uuid", janny: "some janny", rule: 42}

      assert {:ok, %Ban{} = ban} = Bans.create_ban(valid_attrs)
      assert ban.active == true
      assert ban.reason == "some reason"
      assert ban.time == 42
      assert ban.until == 42
      assert ban.uuid == "some uuid"
      assert ban.janny == "some janny"
      assert ban.rule == 42
    end

    test "create_ban/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bans.create_ban(@invalid_attrs)
    end

    test "update_ban/2 with valid data updates the ban" do
      ban = ban_fixture()
      update_attrs = %{active: false, reason: "some updated reason", time: 43, until: 43, uuid: "some updated uuid", janny: "some updated janny", rule: 43}

      assert {:ok, %Ban{} = ban} = Bans.update_ban(ban, update_attrs)
      assert ban.active == false
      assert ban.reason == "some updated reason"
      assert ban.time == 43
      assert ban.until == 43
      assert ban.uuid == "some updated uuid"
      assert ban.janny == "some updated janny"
      assert ban.rule == 43
    end

    test "update_ban/2 with invalid data returns error changeset" do
      ban = ban_fixture()
      assert {:error, %Ecto.Changeset{}} = Bans.update_ban(ban, @invalid_attrs)
      assert ban == Bans.get_ban!(ban.id)
    end

    test "delete_ban/1 deletes the ban" do
      ban = ban_fixture()
      assert {:ok, %Ban{}} = Bans.delete_ban(ban)
      assert_raise Ecto.NoResultsError, fn -> Bans.get_ban!(ban.id) end
    end

    test "change_ban/1 returns a ban changeset" do
      ban = ban_fixture()
      assert %Ecto.Changeset{} = Bans.change_ban(ban)
    end
  end
end
