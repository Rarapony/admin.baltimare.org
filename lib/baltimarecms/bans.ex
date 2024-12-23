defmodule Baltimarecms.Bans do
  @moduledoc """
  The Bans context.
  """

  import Ecto.Query, warn: false
  alias Baltimarecms.Repo

  alias Baltimarecms.Bans.Ban

  @doc """
  Returns the list of bans.

  ## Examples

      iex> list_bans()
      [%Ban{}, ...]

  """
  # In Bans.list_bans/0
  def list_bans do
    # Assuming you have a user association in your Ban schema
    Repo.all(from b in Ban, preload: [:user])
  end

  @doc """
  Gets a single ban.

  Raises `Ecto.NoResultsError` if the Ban does not exist.

  ## Examples

      iex> get_ban!(123)
      %Ban{}

      iex> get_ban!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ban!(id), do: Repo.get!(Ban, id)

  @doc """
  Creates a ban.

  ## Examples

      iex> create_ban(%{field: value})
      {:ok, %Ban{}}

      iex> create_ban(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ban(attrs \\ %{}) do
    %Ban{}
    |> Ban.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ban.

  ## Examples

      iex> update_ban(ban, %{field: new_value})
      {:ok, %Ban{}}

      iex> update_ban(ban, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ban(%Ban{} = ban, attrs) do
    ban
    |> Ban.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ban.

  ## Examples

      iex> delete_ban(ban)
      {:ok, %Ban{}}

      iex> delete_ban(ban)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ban(%Ban{} = ban) do
    Repo.delete(ban)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ban changes.

  ## Examples

      iex> change_ban(ban)
      %Ecto.Changeset{data: %Ban{}}

  """
  def change_ban(%Ban{} = ban, attrs \\ %{}) do
    Ban.changeset(ban, attrs)
  end
end
