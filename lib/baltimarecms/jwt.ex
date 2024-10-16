defmodule Baltimarecms.JWT do
  use Joken.Config

  # Function to verify the JWT
  def verify_token(token) do
    secret = Application.get_env(:baltimarecms, :jwt_secret) ||
            System.get_env("JWT_SECRET") # Fallback if not in config

    # signer = Joken.Signer.create("HS256", "Horsecock")

    case Joken.verify(token, signer) do
      {:ok, claims} -> {:ok, claims}
      {:error, reason} -> {:error, reason}
    end
  end
end