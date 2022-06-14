defmodule OAuthServer.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      # TODO: add unique constraing
      add :username, :string, null: false
      add :password, :string, null: false
    end
  end
end
