defmodule Baltimarecms.AnnouncementsTest do
  use Baltimarecms.DataCase

  alias Baltimarecms.Announcements

  describe "announcements" do
    alias Baltimarecms.Announcements.Announcement

    import Baltimarecms.AnnouncementsFixtures

    @invalid_attrs %{title: nil, content: nil, announcer: nil}

    test "list_announcements/0 returns all announcements" do
      announcement = announcement_fixture()
      assert Announcements.list_announcements() == [announcement]
    end

    test "get_announcement!/1 returns the announcement with given id" do
      announcement = announcement_fixture()
      assert Announcements.get_announcement!(announcement.id) == announcement
    end

    test "create_announcement/1 with valid data creates a announcement" do
      valid_attrs = %{title: "some title", content: "some content", announcer: "some announcer"}

      assert {:ok, %Announcement{} = announcement} = Announcements.create_announcement(valid_attrs)
      assert announcement.title == "some title"
      assert announcement.content == "some content"
      assert announcement.announcer == "some announcer"
    end

    test "create_announcement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Announcements.create_announcement(@invalid_attrs)
    end

    test "update_announcement/2 with valid data updates the announcement" do
      announcement = announcement_fixture()
      update_attrs = %{title: "some updated title", content: "some updated content", announcer: "some updated announcer"}

      assert {:ok, %Announcement{} = announcement} = Announcements.update_announcement(announcement, update_attrs)
      assert announcement.title == "some updated title"
      assert announcement.content == "some updated content"
      assert announcement.announcer == "some updated announcer"
    end

    test "update_announcement/2 with invalid data returns error changeset" do
      announcement = announcement_fixture()
      assert {:error, %Ecto.Changeset{}} = Announcements.update_announcement(announcement, @invalid_attrs)
      assert announcement == Announcements.get_announcement!(announcement.id)
    end

    test "delete_announcement/1 deletes the announcement" do
      announcement = announcement_fixture()
      assert {:ok, %Announcement{}} = Announcements.delete_announcement(announcement)
      assert_raise Ecto.NoResultsError, fn -> Announcements.get_announcement!(announcement.id) end
    end

    test "change_announcement/1 returns a announcement changeset" do
      announcement = announcement_fixture()
      assert %Ecto.Changeset{} = Announcements.change_announcement(announcement)
    end
  end
end
