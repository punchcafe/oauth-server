defmodule OAuthServer.Router do
  import Plug.Conn
  use Plug.Router

  alias OAuthServer.Client.Service, as: ClientService
  alias OAuthServer.User.Service, as: UserService

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  post "/user" do
    %{"username" => username, "password" => password} = conn.params
    case UserService.create(username, password) do
      {:ok, %{username: username}} -> send_resp(conn, 200, Jason.encode!(%{username: username}))
      {:error, err} -> send_resp(conn, 400, Jason.encode!(%{error: err}))
    end
  end

  post "/client" do
    case ClientService.create() do
      {:ok, value} -> send_resp(conn, 200, Jason.encode!(value))
      {:error, err} -> send_resp(conn, 400, Jason.encode!(%{error: err}))
    end
  end

  post "/client/:client_id/url_whitelist" do
    %{"whitelist_url" => url, "client_id" => id} = conn.params
    case ClientService.whitelist_url(id, url) do
      :ok -> send_resp(conn, 200, Jason.encode!(%{}))
      {:error, err} -> send_resp(conn, 400, Jason.encode!(%{error: err}))
    end
  end
end
