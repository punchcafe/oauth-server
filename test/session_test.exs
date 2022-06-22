defmodule OauthServer.SessionTest do
  use ExUnit.Case, async: false

  @username "user_name"
  @password "pass_word"
  @session_cookie_name "_oauth_server_key"

  setup do
    scheme = System.get_env("OAUTH_SERVER_SCHEME")
    port = System.get_env("OAUTH_SERVER_PORT")
    base_url = scheme <> "://" <> System.get_env("OAUTH_SERVER_HOST") <> ":" <> port

    {:ok, %{status: 200, body: %{username: "user_name"}}} =
      HTTPX.post(
        base_url <> "/user",
        {:json, %{username: @username, password: @password}},
        fail: true,
        format: :json_atoms
      )

    %{base_url: base_url}
  end

  defp extract_cookie(%{headers: headers}) do
    headers
    |> Enum.reduce(fn
      {"set-cookie", @session_cookie_name <> "=" <> cookie}, _ -> cookie
      _, _ -> nil
    end)
  end

  describe "login flow" do
    test "/me returns nothing if not logged in", %{base_url: base_url} do
      assert {:ok, %{status: 200, body: "null"}} = HTTPX.get(base_url <> "/me")
      # /user/auth
    end

    test "/me returns self if logged in", %{base_url: base_url} do
      {:ok, resp} =
        HTTPX.post(
          base_url <> "/user/auth",
          {:json, %{username: @username, password: @password}}
        )

      cookie = extract_cookie(resp)
      cookie_header = {"cookie", @session_cookie_name <> "=" <> cookie}
      {:ok, %{body: body}} =
        HTTPX.get(
          base_url <> "/me",
          headers: [cookie_header]
        )

      assert %{"id" => num, "username" => @username} = Jason.decode!(body)
      assert is_number(num)
    end
  end
end
