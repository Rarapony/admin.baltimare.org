defmodule Baltimarecms.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :uuid, :string
    field :username, :string
    field :confirmed_at, :naive_datetime

    timestamps(type: :utc_datetime)
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of UUIDs.

  ## Options

    * `:validate_uuid` - Validates the uniqueness of the uuid, in case
      you don't want to validate the uniqueness of the uuid (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:uuid])
    |> validate_uuid(opts)
  end

  defp validate_uuid(changeset, opts) do
    changeset
    |> validate_required([:uuid])
    |> validate_length(:uuid, max: 160)
    |> maybe_validate_unique_uuid(opts)
  end

  defp maybe_validate_unique_uuid(changeset, opts) do
    if Keyword.get(opts, :validate_uuid, true) do
      changeset
      |> unsafe_validate_unique(:uuid, Baltimarecms.Repo)
      |> unique_constraint(:uuid)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the uuid.

  It requires the uuid to change otherwise an error is added.
  """
  def uuid_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:uuid])
    |> validate_uuid(opts)
    |> case do
      %{changes: %{uuid: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :uuid, "did not change")
    end
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end
end
