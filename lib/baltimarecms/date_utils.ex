defmodule Baltimarecms.DateUtils do
  def date_string_to_unix(date_string) do
    with {:ok, date} <- Date.from_iso8601(date_string),
         {:ok, datetime} <- DateTime.new(date, ~T[00:00:00]) do
      DateTime.to_unix(datetime)
    else
      _ -> {:error, :invalid_date_format}
    end
  end

  def current_time_unix() do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
