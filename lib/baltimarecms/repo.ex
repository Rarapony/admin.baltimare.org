defmodule Baltimarecms.Repo do
  use Ecto.Repo,
    otp_app: :baltimarecms,
    adapter: Ecto.Adapters.MyXQL
end
