defmodule OAuthServer.Repo do
  use Ecto.Repo,
    otp_app: :oauth_server,
    adapter: Ecto.Adapters.Postgres
end
