defmodule Gurren.AccountsTest do
  use Gurren.DataCase

  alias Gurren.Accounts

  describe "users" do
    alias Gurren.Accounts.User

    @valid_attrs %{encrypted_password: "some encrypted_password", username: "some username"}
    @update_attrs %{encrypted_password: "some updated encrypted_password", username: "some updated username"}
    @invalid_attrs %{encrypted_password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.encrypted_password == "some encrypted_password"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.encrypted_password == "some updated encrypted_password"
      assert user.username == "some updated username"
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

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "sessions" do
    alias Gurren.Accounts.Session

    @valid_attrs %{user_agent: "some user_agent"}
    @update_attrs %{user_agent: "some updated user_agent"}
    @invalid_attrs %{user_agent: nil}

    def session_fixture(attrs \\ %{}) do
      {:ok, session} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_session()

      session
    end

    test "list_sessions/0 returns all sessions" do
      session = session_fixture()
      assert Accounts.list_sessions() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Accounts.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      assert {:ok, %Session{} = session} = Accounts.create_session(@valid_attrs)
      assert session.user_agent == "some user_agent"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      assert {:ok, session} = Accounts.update_session(session, @update_attrs)
      assert %Session{} = session
      assert session.user_agent == "some updated user_agent"
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_session(session, @invalid_attrs)
      assert session == Accounts.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Accounts.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = Accounts.change_session(session)
    end
  end
end
