defmodule OAuthServer.Client.Service do
  alias OAuthServer.Client.ORM

  @secret_size 128

  alias OAuthServer.Repo

  def create() do
    id = UUID.uuid1()
    secret = :crypto.strong_rand_bytes(@secret_size) |> Base.encode64()

    with {:ok, %{id: id, secret: secret}} <- Repo.insert(%ORM{id: id, secret: secret}),
         do: {:ok, %{client_id: id, client_secret: secret}}
  end
end
