defmodule Timemachine.DataTest do
  use Timemachine.DataCase

  alias Timemachine.Data

  describe "users" do
    alias Timemachine.Data.User

    import Timemachine.DataFixtures

    @invalid_attrs %{"username" => nil, "email" => nil, "password" => nil}

    test "user_list/0 returns all users" do
      user = user_fixture()
      assert Data.user_list() == [user]
    end

    test "user_get/1 returns the user with given id" do
      user = user_fixture()
      assert Data.user_get(user.id) == user
    end

    test "user_create/1 with valid data creates a user" do
      valid_attrs = %{"username" => "some username", "email" => "some@email.com", "password" => "mdp"}

      assert {:ok, %User{} = user} = Data.user_create(valid_attrs)
      assert user.username == "some username"
      assert user.email == "some@email.com"
    end

    test "user_create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.user_create(@invalid_attrs)
    end

    test "user_update/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{"username" => "some updated username", "email" => "someupdated@email.com", "password" => "mdp"}

      assert {:ok, %User{} = user} = Data.user_update(user, update_attrs)
      assert user.username == "some updated username"
      assert user.email == "someupdated@email.com"
    end

    test "user_update/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.user_update(user, @invalid_attrs)
      assert user == Data.user_get(user.id)
    end

    test "user_delete/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Data.user_delete(user)
      assert_raise Ecto.NoResultsError, fn -> Data.user_get(user.id) end
    end
  end

  describe "teams" do
    alias Timemachine.Data.Team

    import Timemachine.DataFixtures

    @invalid_attrs %{name: nil}

    test "team_list/0 returns all teams" do
      team = team_fixture()
      assert Data.team_list() == [team]
    end

    test "team_get/1 returns the team with given id" do
      team = team_fixture()
      assert Data.team_get(team.id) == team
    end

    test "team_create/1 with valid data creates a team" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Team{} = team} = Data.team_create(valid_attrs)
      assert team.name == "some name"
    end

    test "team_create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.team_create(@invalid_attrs)
    end

    test "team_update/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Team{} = team} = Data.team_update(team, update_attrs)
      assert team.name == "some updated name"
    end

    test "team_update/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.team_update(team, @invalid_attrs)
      assert team == Data.team_get(team.id)
    end

    test "team_delete/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Data.team_delete(team)
      assert_raise Ecto.NoResultsError, fn -> Data.team_get(team.id) end
    end

    test "team_change/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Data.team_change(team)
    end
  end
end
