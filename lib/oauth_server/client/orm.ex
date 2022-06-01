defmodule OAuthServer.Client.ORM do
  use Ecto.Schema

  @primary_key {:id, :string, autogenerate: false}

  schema "client" do
    field(:secret, :string)
  end
end
