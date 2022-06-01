defmodule OAuthServer.Repo.Migrations.AddClientEntity do
  use Ecto.Migration

  def change do
    create table(:client, primary_key: false) do
      add :id, :string, primary_key: true
      add :secret, :string, null: false
    end
  end
end
