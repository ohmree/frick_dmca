defmodule FrickDmca.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias FrickDmca.Repo

  alias FrickDmca.Users.User
  alias FrickDmca.Users.StreamerInfo


  @type t :: %User{}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

  """
  def get_user!(id) do
    Repo.get!(User, id)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, ...}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, ...}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, ...}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns a data structure for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Todo{...}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @spec create_admin(map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def create_admin(params) do
    %User{}
    |> User.changeset(params)
    |> User.changeset_role(%{role: "admin"})
    |> Repo.insert()
  end

  @spec set_admin_role(t()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def set_admin_role(user) do
    user
    |> User.changeset_role(%{role: "admin"})
    |> Repo.update()
  end

  def create_streamer_info(attrs \\ %{}) do
    %StreamerInfo{}
    |> StreamerInfo.changeset(attrs)
    |> Repo.insert()
  end

  def start_streaming(%User{} = user, attrs \\ %{}) do
    user = Repo.preload(user, :streamer_info)
    if user.streamer_info do
      user
    else
      with {:ok, streamer_info} <- create_streamer_info(attrs) do
        user
        |> change_user()
        |> Ecto.Changeset.put_assoc(:streamer_info, streamer_info |> StreamerInfo.changeset(%{}))
        |> Repo.update()
      end
    end
  end

  def stop_streaming(%User{} = user) do
    user = Repo.preload(user, :streamer_info)
    if !user.streamer_info do
      user
    else
      with {:ok, _} <- Repo.delete(user.streamer_info) do
        user
      end
    end
  end

  def set_song(%User{} = user, song) do
    user = Repo.preload(user, :streamer_info)

    user.streamer_info
    |> Repo.preload(:song)
    |> StreamerInfo.changeset(%{})
    |> Ecto.Changeset.put_assoc(:song, song)
    |> Repo.update()
  end

  def streaming?(%User{} = user) do
    user = Repo.preload(user, :streamer_info)
    !is_nil(user.streamer_info)
  end
end
