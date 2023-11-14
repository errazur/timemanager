defmodule Timemachine.Data do
  @moduledoc """
  The Data context for managing data operations in the Timemachine application.
  """
  import Ecto.Query, warn: false
  alias Timemachine.Repo

  alias Timemachine.Data.Clock

  @doc """
  Creates a clock entry for the given `user_id`.

  ## Parameters

  - `attrs` (type: map, default: %{}): Map containing attributes for the clock entry. Should include `"status"` and `"time"`.
  - `user_id` (type: integer()): The user ID for whom the clock entry is created.

  ## Returns

  Returns `:ok` if the clock entry is successfully created.

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
  Returns the last clock entry made by the user with the given `user_id`.

  ## Parameters

  - `user_id` (type: integer()): The user ID for whom the last clock entry is retrieved.

  ## Returns

  Returns the last clock entry as a `%Clock{}` struct.

  """
  def clock_get_last_by_user_id(user_id) do
    Repo.one(from(c in Clock, where: [user_id: ^user_id], order_by: [desc: c.id], limit: 1, preload: :user))
  end

  @doc """
  Returns all clock entries made by the user with the given `user_id`.

  ## Parameters

  - `user_id` (type: integer()): The user ID for whom the clock entries are retrieved.

  ## Returns

  Returns a list of clock entries as `%Clock{}` structs.

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
  Creates a new team.

  ## Parameters

  - `attrs` (type: map, default: %{}): Map containing attributes for the team. Should include `"name"`.

  ## Returns

  Returns `:ok` if the team is successfully created.

  """
  def team_create(attrs \\ %{}) do
    %Team{}
    |> Repo.preload(:users)
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes the given team.

  ## Parameters

  - `team` (type: %Team{}): The team to be deleted.

  ## Returns

  Returns `:ok` if the team is successfully deleted.

  """
  def team_delete(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns the team with the same `id`.

  ## Parameters

  - `id` (type: any()): The ID of the team to be retrieved.

  ## Returns

  Returns the team as a `%Team{}` struct.

  """
  def team_get(id) do
    Repo.get!(Team, id)
    |> Repo.preload(:users)
  end

  @doc """
  Returns all teams.

  ## Returns

  Returns a list of teams as `%Team{}` structs.

  """
  def team_list do
    Repo.all(from t in Team, order_by: :id)
    |> Repo.preload(:users)
  end

  @doc """
  Edits the team with the given `attrs`.

  ## Parameters

  - `team` (type: %Team{}): The team to be updated.
  - `attrs` (type: map()): Map containing attributes for the team. Can include `"name"`.

  ## Returns

  Returns `:ok` if the team is successfully updated.

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
  Creates a new user.

  ## Parameters

  - `attrs` (type: map()): Map containing user attributes, including `"username"`, `"email"`, `"password"`, and an optional `"role"`.

  ## Returns

  Returns the newly created user, preloaded with associated teams.

  """
  def user_create(attrs \\ %{}) do
    %User{role: User.default_role()}
    |> Repo.preload(:teams)
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes the given user.

  ## Parameters

  - `user` (type: %User{}): The user to be deleted.

  ## Returns

  Returns `:ok` if the user is successfully deleted.

  """
  def user_delete(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns the team with the same `id`.

  ## Parameters

  - `id` (type: any()): The ID of the user to be retrieved.

  ## Returns

  Returns the user as a `%User{}` struct.

  """
  def user_get(id) do
    Repo.get!(User, id)
    |> Repo.preload(:teams)
  end

  @doc """
  Searches for users based on the specified parameters.

  ## Parameters

  - `params` (type: map()): Map containing search parameters. Can include `"username"` and `"email"`.

  ## Returns

  Returns a list of users as `%User{}` structs.

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
  Tries to authenticate the user.

  ## Parameters

  - `credentials` (type: map()): Map containing credentials with keys `"username"` and `"password"`.

  ## Returns

  Returns `{:ok, user}` if authentication is successful, or `{:error, 401}` if not.

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
  Tries to authenticate the user.

  ## Parameters

  - `user_id` (type: any()): The ID of the user.
  - `password` (type: string()): The user's password.

  ## Returns

  Returns `{:ok, user}` if authentication is successful, or `{:error, 401}` if not.

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
  Updates the user's information.

  ## Parameters

  - `user` (type: %User{}): The user to be updated.
  - `attrs` (type: map()): Map containing attributes to be updated.

  ## Returns

  Returns `:ok` if the user is successfully updated.

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
  Creates a new user-team relationship.

  ## Parameters

  - `user_id` (type: any()): The ID of the user.
  - `team_id` (type: any()): The ID of the team.

  ## Returns

  Returns `:ok` if the user-team relationship is successfully created.

  """
  def userteam_create(user_id, team_id) do
    %UserTeam{}
    |> UserTeam.changeset(%{"user_id" => user_id, "team_id" => team_id})
    |> Repo.insert()
  end

  @doc """
  Deletes an existing user-team relationship.

  ## Parameters

  - `user_id` (type: any()): The ID of the user.
  - `team_id` (type: any()): The ID of the team.

  ## Returns

  Returns `:ok` if the user-team relationship is successfully deleted.

  """
  def userteam_delete(user_id, team_id) do
    Repo.one(from(ut in UserTeam, where: [user_id: ^user_id, team_id: ^team_id]))
    |> Repo.delete()
  end

  alias Timemachine.Data.Workingtime

  @doc """
  Creates a new working time entry.

  ## Parameters

  - `attrs` (type: map, default: %{}): Map containing attributes for the working time. Should include `"start"` and `"end"`.
  - `user_id` (type: any()): The ID of the user.

  ## Returns

  Returns `:ok` if the working time entry is successfully created.

  """
  def workingtime_create(attrs \\ %{}, user_id) do
    %Workingtime{user_id: user_id}
    |> Repo.preload(:user)
    |> Workingtime.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user_get(user_id))
    |> Repo.insert()
  end

  @doc """
  Deletes an existing working time entry.

  ## Parameters

  - `workingtime` (type: %Workingtime{}): The working time entry to be deleted.

  ## Returns

  Returns `:ok` if the working time entry is successfully deleted.

  """
  def workingtime_delete(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  @doc """
  Generates a new working time entry based on the last clock entry.

  ## Parameters

  - `user_id` (type: any()): The ID of the user.
  - `end_time` (type: any()): The end time of the working time.

  ## Returns

  Returns `:ok` if the working time entry is successfully generated.

  """
  def workingtime_generate(user_id, end_time) do
    last_clock = clock_get_last_by_user_id(user_id)
    if Map.get(last_clock, :status) == true do
      workingtime_create(%{"start" => Map.get(last_clock, :time), "end" => end_time}, user_id)
    end
  end

  @doc """
  Returns the working time entry with the same `id`.

  ## Parameters

  - `id` (type: any()): The ID of the working time entry.

  ## Returns

  Returns the working time entry as a `%Workingtime{}` struct.

  """
  def workingtime_get(id) do
    Repo.get!(Workingtime, id)
    |> Repo.preload(:user)
  end

  @doc """
  Returns a list of all working time entries.

  ## Returns

  Returns a list of working time entries as `%Workingtime{}` structs.

  """
  def workingtime_list do
    Repo.all(from w in Workingtime, order_by: :id)
    |> Repo.preload(:user)
  end

  @doc """
  Searches for working time entries within a specified time range.

  ## Parameters

  - `user_id` (type: any()): The ID of the user.
  - `start_working` (type: any()): The start of the time range for the working time entries.
  - `end_working` (type: any()): The end of the time range for the working time entries.

  ## Returns

  Returns a list of working time entries within the specified time range.

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
  Updates an existing working time entry.

  ## Parameters

  - `workingtime` (type: %Workingtime{}): The working time entry to be updated.
  - `attrs` (type: map()): Map containing attributes to be updated.

  ## Returns

  Returns `:ok` if the working time entry is successfully updated.

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
