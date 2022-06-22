defmodule OAuthServer.Session.Service do
  alias OAuthServer.User.Service, as: UserService

  @type session :: %{id: Binary.t()}
  def create_session(_user = %{username: username, id: id}), do: {:ok, %{id: id}}

  def fetch_user!(%{id: id}) do
    case UserService.get(id) do
      {:ok, user} -> user
      _ -> raise "Failed to fetch user from session"
    end
  end
end
