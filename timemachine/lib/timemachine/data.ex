defmodule Timemachine.Data do
  @moduledoc """
  The Data context.
  """
  import Ecto.Query, warn: false
  alias Timemachine.Repo

  alias Timemachine.Data.Clock

  @doc """
  Creates a clock for the given `user_id`. `attrs` should contains `"status"` and `"time"`.
  """
  def clock_create(attrs \\ %{}, user_id) do
    # Génère l'horloge si le statut est faux
    if attrs["status"] == false, do: workingtime_generate(user_id, attrs["time"])

    %Clock{user_id: user_id}
    |> Repo.preload(:user)
    |> Clock.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user_get(user_id))
    |> Repo.insert()
  end

  @doc """
  Returns the last clock made by the user `user_id`.
  """
  def clock_get_last_by_user_id(user_id) do
    Repo.one(from(c in Clock, where: [user_id: ^user_id], order_by: [desc: c.id], limit: 1, preload: :user))
  end

  @doc """
  Returns all clocks made by the user `user_id`.
  """
  def clock_list_by_user_id(user_id) do
    Repo.all(from(c in Clock, where: [user_id: ^user_id], order_by: :id, preload: :user))
  end

  @doc false
  def clock_change(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  alias Timemachine.Data.Team

  @doc """
  Creates a new team. `attrs` should contain `"name"`.
  """
  def team_create(attrs \\ %{}) do
    %Team{}
    |> Repo.preload(:users)
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes the given team.
  """
  def team_delete(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns the team with the same `id`.
  """
  def team_get(id) do
    Repo.get!(Team, id)
    |> Repo.preload(:users)
  end

  @doc """
  Returns all teams.
  """
  def team_list do
    Repo.all(from t in Team, order_by: :id)
    |> Repo.preload(:users)
  end

  @doc """
  Edits the team with the given `attrs`. `attrs` can contain `"name"`.
  """
  def team_update(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc false
  def team_change(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  alias Timemachine.Data.User

  @doc """
  Creates a new user. `attrs` should contain `"username"`, `"email"`, `"password"` and a optional `"role"`.
  """
  def user_create(attrs \\ %{}) do
    %User{role: User.default_role()}
    |> Repo.preload(:teams)
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes the given user.
  """
  def user_delete(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns the team with the same `id`.
  """
  def user_get(id) do
    Repo.get!(User, id)
    |> Repo.preload(:teams)
  end

  @doc """
  Returns the bearer token from a `conn` by reading `authorization` header.
  """
  def user_search(params) do
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

  @doc """
  Tries to authenticate the user. `credentials` is a `Map` with keys `"username"` and `"password"`.
  """
  def user_try_login(%{"username" => username, "password" => password} = _credentials) do
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

  @doc """
  Returns the bearer token from a `conn` by reading `authorization` header.
  """
  def user_try_login(user_id, password) do
    case user_get(user_id) do
      nil -> {:error, 401}
      user ->
        if :crypto.hash_equals(user.password_hash, :crypto.hash(:sha256, password)) do
          {:ok, user}
        else
          {:error, 401}
        end
    end
  end

  @doc """
  Returns the bearer token from a `conn` by reading `authorization` header.
  """
  def user_update(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc false
  def user_change(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc false
  def user_list do
    Repo.all(from u in User, order_by: :id)
    |> Repo.preload(:teams)
  end

  alias Timemachine.Data.UserTeam

  @doc """
  Returns the bearer token from a `conn` by reading `authorization` header.
  """
  def userteam_create(user_id, team_id) do
    %UserTeam{}
    |> UserTeam.changeset(%{"user_id" => user_id, "team_id" => team_id})
    |> Repo.insert()
  end

  @doc """
  Returns the bearer token from a `conn` by reading `authorization` header.
  """
  def userteam_delete(user_id, team_id) do
    Repo.one(from(ut in UserTeam, where: [user_id: ^user_id, team_id: ^team_id]))
    |> Repo.delete()
  end

  alias Timemachine.Data.Workingtime

  @doc """
  Returns the bearer token from a `conn` by reading `authorization` header.
  """
  def workingtime_create(attrs \\ %{}, user_id) do
    %Workingtime{user_id: user_id}
    |> Repo.preload(:user)
    |> Workingtime.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user_get(user_id))
    |> Repo.insert()
  end

  @doc """
  Returns the bearer token from a `conn` by reading `authorization` header.
  """
  def workingtime_delete(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  @doc """
  Returns the bearer token from a `conn` by reading `authorization` header.
  """
  def workingtime_generate(user_id, end_time) do
    last_clock = clock_get_last_by_user_id(user_id)
    if Map.get(last_clock, :status) == true do
      workingtime_create(%{"start" => Map.get(last_clock, :time), "end" => end_time}, user_id)
    end
  end

  @doc """
  Returns the workingtime with the same `id`.
  """
  def workingtime_get(id) do
    Repo.get!(Workingtime, id)
    |> Repo.preload(:user)
  end

  @doc """
  Returns the bearer token from a `conn` by reading `authorization` header.
  """
  def workingtime_list do
    Repo.all(from w in Workingtime, order_by: :id)
    |> Repo.preload(:user)
  end

  @doc """
  Returns the bearer token from a `conn` by reading `authorization` header.
  """
  def workingtime_search(user_id, start_working, end_working) do
    query = from(w in Workingtime, where: [user_id: ^user_id], order_by: :id, preload: :user)

    query = if start_working,
      do: where(query, [w], w.start >= ^start_working),
      else: query

    query = if start_working,
      do: where(query, [w], w.end <= ^end_working),
      else: query

    Repo.all(query)
  end

  @doc """
  Returns the bearer token from a `conn` by reading `authorization` header.
  """
  def workingtime_update(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.changeset(attrs)
    |> Repo.update()
  end


  @doc false
  def workingtime_change(%Workingtime{} = workingtime, attrs \\ %{}) do
    Workingtime.changeset(workingtime, attrs)
  end

end
