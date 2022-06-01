import Config

config :oauth_server, OAuthServer.Repo,
  database: System.get_env("POSTGRES_DATABASE") || "postgres",
  username: System.get_env("POSTGRES_USERNAME") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "guest",
  hostname: System.get_env("POSTGRES_HOSTNAME") || "localhost",
  ssl: System.get_env("POSTGRES_SSL") in ["true", "TRUE"] || false

config :oauth_server, port: String.to_integer(System.get_env("OAUTH_SERVER_PORT"))
