defmodule OAuthServer do
  @moduledoc """
  Documentation for `OauthImplementation`.
  """

  def start(_, _) do
    port = Application.fetch_env!(:oauth_server, :port)

    children = [
      {Plug.Cowboy, scheme: :http, plug: OAuthServer.Router, options: [port: port]},
      OAuthServer.Repo
    ]

    opts = [strategy: :one_for_one, name: OAuthServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
