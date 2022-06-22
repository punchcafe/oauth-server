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
      assert {:ok, %{status: 200, body: %{client_id: client_id, client_secret: client_secret}}} =
               HTTPX.post(base_url <> "/client", {:json, %{}}, fail: true, format: :json_atoms)
    end
  end

  describe "whitelisting" do
    test "can whitelist a uri", %{base_url: base_url} do
      {:ok, %{status: 200, body: %{client_id: client_id}}} =
        HTTPX.post(base_url <> "/client", {:json, %{}}, fail: true, format: :json_atoms)

      assert {:ok, %{status: 200}} =
               HTTPX.post(
                 base_url <> "/client/" <> client_id <> "/url_whitelist",
                 {:json,
                  %{client_id: client_id, whitelist_url: "https://www.helloworld.com/my_path"}}
               )
    end
  end
end
