defmodule OAuthServer.Router do
  import Plug.Conn
  use Plug.Router

  alias OAuthServer.Client.Service, as: ClientService

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  post "/client" do
    case ClientService.create() do
      {:ok, value} -> send_resp(conn, 200, Jason.encode!(value))
      {:error, err} -> send_resp(conn, 400, Jason.encode!(%{error: err}))
    end
  end
end
