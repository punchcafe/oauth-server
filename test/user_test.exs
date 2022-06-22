defmodule OauthServer.UserTest do
  use ExUnit.Case, async: false

  setup do
    scheme = System.get_env("OAUTH_SERVER_SCHEME")
    port = System.get_env("OAUTH_SERVER_PORT")
    base_url = scheme <> "://" <> System.get_env("OAUTH_SERVER_HOST") <> ":" <> port
    %{base_url: base_url}
  end

  describe "dev user creation" do
    test "can create a user", %{base_url: base_url} do
      assert {:ok, %{status: 200, body: %{username: "user_name"}}} =
               HTTPX.post(
                 base_url <> "/user",
                 {:json, %{username: "user_name", password: "password"}},
                 fail: true,
                 format: :json_atoms
               )
    end
  end
end
