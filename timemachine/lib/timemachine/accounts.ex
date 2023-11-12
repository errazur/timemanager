defmodule Timemachine.Accounts do
  import Ecto.Query, warn: false
  alias Timemachine.Repo

  alias Timemachine.Accounts.User

  def list_users do
    Repo.all(from u in User, order_by: :id)
    |> Repo.preload(:teams)
  end

  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:teams)
  end

  def search_user(params) do
    query = from u in User, order_by: :id, preload: :teams

    username = Map.get(params, "username")
    query = if username,
      do: where(query, [u], ilike(u.username, ^"%#{username}%")),
      else: query

    email = Map.get(params, "email")
    query = if email,
      do: where(query, [u], ilike(u.email, ^"%#{email}%")),
      else: query

    Repo.all(query)
  end

  def try_login(%{"username" => username, "password" => password}) do
    case Repo.one(from(u in User, where: [username: ^username], limit: 1, preload: :teams)) do
      nil -> {:error, 401}
      user ->
        if :crypto.hash_equals(user.password_hash, :crypto.hash(:sha256, password)) do
          {:ok, user}
        else
          {:error, 401}
        end
    end
  end

  def create_user(attrs \\ %{}) do
    %User{role: User.default_role()}
    |> Repo.preload(:teams)
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias Timemachine.Accounts.Clock

  def get_clocks!(user_id) do
    Repo.all(from(c in Clock, where: [user_id: ^user_id], order_by: :id, preload: :user))
  end

  def create_clock(attrs \\ %{}, user_id) do
    # Génère l'horloge si le statut est faux
    if attrs["status"] == false, do: generate_workingtime(user_id, attrs["time"])

    %Clock{user_id: user_id}
    |> Repo.preload(:user)
    |> Clock.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, get_user!(user_id))
    |> Repo.insert()
  end

  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end


  def get_last_clock(user_id) do
    Repo.one(from(c in Clock, where: [user_id: ^user_id], order_by: [desc: c.id], limit: 1, preload: :user))
  end

  alias Timemachine.Accounts.Workingtime

  def list_workingtimes do
    Repo.all(from w in Workingtime, order_by: :id)
    |> Repo.preload(:user)
  end

  def get_workingtime!(id) do
    Repo.get!(Workingtime, id)
    |> Repo.preload(:user)
  end

  def search_workingtimes(user_id, start_working, end_working) do
    query = from(w in Workingtime, where: [user_id: ^user_id], order_by: :id, preload: :user)

    query = if start_working,
      do: where(query, [w], w.start >= ^start_working),
      else: query

    query = if start_working,
      do: where(query, [w], w.end <= ^end_working),
      else: query

    Repo.all(query)
  end

  def create_workingtime(attrs \\ %{}, user_id) do
    %Workingtime{user_id: user_id}
    |> Repo.preload(:user)
    |> Workingtime.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, get_user!(user_id))
    |> Repo.insert()
  end

  def generate_workingtime(user_id, end_time) do
    last_clock = get_last_clock(user_id)
    if Map.get(last_clock, :status) == true do
      create_workingtime(%{"start" => Map.get(last_clock, :time), "end" => end_time}, user_id)
    end
  end

  def update_workingtime(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.changeset(attrs)
    |> Repo.update()
  end

  def delete_workingtime(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  def change_workingtime(%Workingtime{} = workingtime, attrs \\ %{}) do
    Workingtime.changeset(workingtime, attrs)
  end

  alias Timemachine.Accounts.Team

  def list_teams do
    Repo.all(from t in Team, order_by: :id)
    |> Repo.preload(:users)
  end

  def get_team!(id) do
    Repo.get!(Team, id)
    |> Repo.preload(:users)
  end

  def create_team(attrs \\ %{}) do
    %Team{}
    |> Repo.preload(:users)
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  alias Timemachine.Accounts.UserTeam

  def create_user_team(user_id, team_id) do
    %UserTeam{}
    |> UserTeam.changeset(%{"user_id" => user_id, "team_id" => team_id})
    |> Repo.insert()
  end

  def delete_user_team(user_id, team_id) do
    Repo.one(from(ut in UserTeam, where: [user_id: ^user_id, team_id: ^team_id]))
    |> Repo.delete()
  end
end
