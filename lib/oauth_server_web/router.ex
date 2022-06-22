defmodule OAuthServer.Router do
  require Logger

  import Plug.Conn
  alias Plug.Conn
  use Plug.Router

  alias OAuthServer.Client.Service, as: ClientService
  alias OAuthServer.User.Service, as: UserService
  alias OAuthServer.Session.Service, as: SessionService

  plug(
    Plug.Session,
    store: :cookie,
    key: "_oauth_server_key",
    signing_salt: "hello_world",
    secret_key_base: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  )

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

  # TODO: only for debug/testing
  get "/me" do
    # TODO: make session fetch part of plug
    case conn |> Conn.fetch_session() |> Conn.get_session(:logged_in) do
      nil ->
        send_resp(conn, 200, Jason.encode!(nil))

      session ->
        session |> SessionService.fetch_user!() |> then(&send_resp(conn, 200, Jason.encode!(&1)))
    end
  end

  post "/client" do
    case ClientService.create() do
      {:ok, value} -> send_resp(conn, 200, Jason.encode!(value))
      {:error, err} -> send_resp(conn, 400, Jason.encode!(%{error: err}))
    end
  end

  post "/user/auth" do
    %{"username" => username, "password" => password} = conn.params

    with {:ok, user} <- UserService.auth(username, password),
         {:ok, session} <- SessionService.create_session(user) do
      conn |> Conn.fetch_session() |> Conn.put_session(:logged_in, session) |> send_resp(200, "")
    else
      {:error, error} ->
        Logger.warn("failure logging in", error: error)
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
