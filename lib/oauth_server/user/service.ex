defmodule OAuthServer.User.Service do
  alias OAuthServer.User.ORM
  alias OAuthServer.Repo

  import Ecto.Query, only: [from: 2]
  require Logger

  @type user_optional_fields :: %{email: String.t() | nil}
  def create(username, password) when is_binary(username) and is_binary(password) do
    # TODO: add robustness to checks without using ecto changeset
    case Repo.insert(%ORM{username: username, password: password}) do
      {:ok, %{username: username}} ->
        {:ok, %{username: username}}

      err = {:error, _} ->
        Logger.error("Failed to add user", error: err)
        {:error, :failed_update}
    end
  end

  # TODO: add unit tests?
  def get(id) when is_integer(id) do
    if user = Repo.get(ORM, id), do: {:ok, orm_to_model(user)}, else: {:error, :not_found}
  end

  def auth(username, password) do
    query =
      from(user in ORM, where: user.username == ^username and user.password == ^password, limit: 1)

    with [%{id: id}] <- Repo.all(query) do
      {:ok, %{username: username, id: id}}
    else
      _ -> {:error, :auth_failed}
    end
  end

  defp orm_to_model(%ORM{username: username, id: id}), do: %{username: username, id: id}
end
