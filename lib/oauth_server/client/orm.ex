defmodule OAuthServer.Client.ORM do
  alias OAuthServer.Client.Whitelist
  use Ecto.Schema

  @primary_key {:id, :string, autogenerate: false}

  schema "clients" do
    field(:secret, :string)
    has_many(:whitelisted_urls, Whitelist.ORM, foreign_key: :client_id)
  end
end
