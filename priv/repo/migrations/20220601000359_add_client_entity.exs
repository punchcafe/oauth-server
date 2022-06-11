defmodule OAuthServer.Repo.Migrations.AddClientEntity do
  use Ecto.Migration

  def change do
    create table(:clients, primary_key: false) do
      add :id, :string, primary_key: true
      add :secret, :string, null: false
    end

    create table(:client_whitelists) do
      add :url, :string, null: false
      add :client_id, references("clients", type: :string)
    end
  end
end
