defmodule Baltimarecms.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Baltimarecms.Repo

  alias Baltimarecms.Accounts.{User, UserToken, UserNotifier}

  ## Database getters

  def list_users do
    Repo.all(User)
  end

  def get_user_by_uuid(uuid) when is_binary(uuid) do
    Repo.get_by(User, uuid: uuid)
  end

  def get_user_by_email_token(token, context) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, context),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  def get_user!(id), do: Repo.get!(User, id)

  ## User registration

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def confirm_user(%User{confirmed_at: confirmed_at} = user) when is_nil(confirmed_at) do
    user
    |> User.confirm_changeset()
    |> Repo.update()
  end

  def confirm_user(%User{confirmed_at: confirmed_at} = user) when not is_nil(confirmed_at) do
    {:ok, user}
  end

  def change_user_uuid(user, attrs \\ %{}) do
    User.uuid_changeset(user, attrs, validate_uuid: false)
  end

  def apply_user_uuid(user, attrs) do
    user
    |> User.uuid_changeset(attrs)
    |> Ecto.Changeset.apply_action(:update)
  end

  def update_user_uuid(user, token) do
    context = "change:#{user.uuid}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: uuid} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_uuid_multi(user, uuid, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_uuid_multi(user, uuid, context) do
    changeset =
      user
      |> User.uuid_changeset(%{uuid: uuid})
      |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, [context]))
  end

  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"))
    :ok
  end

  ## Authentication

  def login_or_register_user(uuid) do
    case get_user_by_uuid(uuid) do
      # Found existing user.
      %User{} = user ->
        {email_token, token} = UserToken.build_email_token(user, "magic_link")
        Repo.insert!(token)

        UserNotifier.deliver_login_link(
          user,
          "#{BaltimarecmsWeb.Endpoint.url()}/login/email/token/#{email_token}"
        )

      # New user, create a new account.
      _ ->
        {:ok, user} = register_user(%{uuid: uuid})

        {email_token, token} = UserToken.build_email_token(user, "magic_link")
        Repo.insert!(token)

        UserNotifier.deliver_login_link(
          user,
          "#{BaltimarecmsWeb.Endpoint.url()}/login/email/token/#{email_token}"
        )
    end
  end
end
