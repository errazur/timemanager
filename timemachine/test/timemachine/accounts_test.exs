defmodule Timemachine.AccountsTest do
  use Timemachine.DataCase

  alias Timemachine.Accounts

  describe "users" do
    alias Timemachine.Accounts.User

    import Timemachine.AccountsFixtures

    @invalid_attrs %{"username" => nil, "email" => nil, "password" => nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{"username" => "some username", "email" => "some@email.com", "password" => "mdp"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.username == "some username"
      assert user.email == "some@email.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{"username" => "some updated username", "email" => "someupdated@email.com", "password" => "mdp"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.username == "some updated username"
      assert user.email == "someupdated@email.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end
end
