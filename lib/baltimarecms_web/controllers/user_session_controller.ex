defmodule BaltimarecmsWeb.UserSessionController do
  use BaltimarecmsWeb, :controller

  alias Baltimarecms.Accounts
  alias BaltimarecmsWeb.UserAuth
  alias Baltimarecms.Accounts.User

  def send_magic_link(conn, params) do
    %{"user" => %{"uuid" => uuid}} = params

    Accounts.login_or_register_user(uuid)

    conn
    |> put_flash(:info, "We've sent an email to #{uuid}, with a one-time sign-in link.")
    |> redirect(to: ~p"/login")
  end

  def login_with_token(conn, %{"token" => token} = _params) do
    case Accounts.get_user_by_email_token(token, "magic_link") do
      %User{} = user ->
        {:ok, user} = Accounts.confirm_user(user)

        conn
        |> put_flash(:info, "Logged in successfully.")
        |> UserAuth.login_user(user)

      _ ->
        conn
        |> put_flash(:error, "That link didn't seem to work. Please try again.")
        |> redirect(to: ~p"/login")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
