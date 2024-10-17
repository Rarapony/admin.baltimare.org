defmodule Baltimarecms.JWT do
  use Joken.Config

  # Function to verify the JWT
  def verify_token(token) do
    secret = System.get_env("JWT_TOKEN")
    signer = Joken.Signer.create("HS256", secret || "Horsecock")

    case Joken.verify(token, signer) do
      {:ok, claims} -> {:ok, claims}
      {:error, reason} -> {:error, reason}
    end
  end
end
