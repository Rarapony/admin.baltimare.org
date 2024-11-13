defmodule Baltimarecms.Accounts.UserNotifier do
  alias HTTPoison

  def deliver_login_link(user, login_link) do
    url = "https://api.baltimare.org/corrade/account/login"

    # Prepare the payload
    payload = %{
      user_uuid: user.uuid,
      login_link: login_link
    }
    |> Jason.encode!()  # encode map to JSON string

    # Set headers
    headers = [{"Content-Type", "application/json"}]

    # Send POST request
    case HTTPoison.post(url, payload, headers) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        IO.puts("Login link sent successfully.")
        :ok

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        IO.puts("Failed to deliver login link. Status code: #{status_code}")
        {:error, :external_service_error}

      {:error, reason} ->
        IO.puts("Error delivering login link: #{inspect(reason)}")
        {:error, reason}
    end

  end
end
