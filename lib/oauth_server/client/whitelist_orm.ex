defmodule OAuthServer.Client.Whitelist.ORM do
  alias OAuthServer.Client.ORM, as: ClientORM
  use Ecto.Schema

  schema "client_whitelists" do
    field(:url, :string)
    belongs_to(:client, ClientORM, references: :id, type: :string)
  end
end
