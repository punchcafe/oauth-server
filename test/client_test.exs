defmodule OauthServer.ClientTest do
  use ExUnit.Case, async: false

  setup do
    scheme = System.get_env("OAUTH_SERVER_SCHEME")
    port = System.get_env("OAUTH_SERVER_PORT")
    base_url = scheme <> "://" <> System.get_env("OAUTH_SERVER_HOST") <> ":" <> port
    %{base_url: base_url}
  end

  describe "dev user creation" do
    test "can create a dev user", %{base_url: base_url} do
      {:ok, %{status: 200, body: %{client_id: client_id, client_secret: client_secret}}} =
        HTTPX.post(base_url <> "/client", {:json, %{}}, fail: true, format: :json_atoms)
    end
  end
end
