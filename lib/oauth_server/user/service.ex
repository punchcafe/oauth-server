defmodule OAuthServer.User.Service do
  alias OAuthServer.User.ORM
  alias OAuthServer.Repo

  require Logger

  @type user_optional_fields :: %{email: String.t() | nil}
  def create(username, password) when is_binary(username) and is_binary(password) do
    # TODO: add robustness to checks without using ecto changeset
    case Repo.insert(%ORM{username: username, password: password}) do
      {:ok, %{username: username}} -> {:ok, %{username: username}}
      err = {:error, _} ->
        Logger.error("Failed to add user", error: err)
        {:error, :failed_update}
    end
  end

  # def authenticate(username, password)

end
