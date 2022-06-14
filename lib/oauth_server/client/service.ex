defmodule OAuthServer.Client.Service do
  require Logger
  alias OAuthServer.Client.ORM
  alias OAuthServer.Client.Whitelist.ORM, as: WhitelistORM
  alias OAuthServer.Repo

  @secret_size 128

  def create() do
    id = UUID.uuid1()
    secret = :crypto.strong_rand_bytes(@secret_size) |> Base.encode64()

    with {:ok, %{id: id, secret: secret}} <- Repo.insert(%ORM{id: id, secret: secret}),
         do: {:ok, %{client_id: id, client_secret: secret}}
  end

  def exists?(client_id) do
    if Repo.get(ORM, client_id), do: true, else: false
  end

  @spec whitelist_url(client_id :: String.t(), url :: URI.t() | String.t()) :: :ok | {:error, atom()}
  def whitelist_url(client_id, url)
  def whitelist_url(client_id, url) when is_binary(url) and is_binary(client_id) do
    whitelist_url(client_id, URI.parse(url))
  end

  def whitelist_url(client_id, %URI{host: host, scheme: "https", path: path}) when is_binary(client_id) and is_binary(host) do
    if exists?(client_id) do
      with {:ok, _} <- Repo.insert(%WhitelistORM{url: "https://" <> host <> path, client_id: client_id}) do
        :ok
      else
        err -> Logger.error("something went wrong whitelisting the url", error: inspect(err))
        {:error, :whitelist_failed}
      end
    else
      {:error, :client_not_found}
    end
  end
end
