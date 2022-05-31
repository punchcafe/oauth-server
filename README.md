# OauthImplementation

## Implementation Plan

```
entities:

access_token:
token(id) | user_id | client_id | scopes
refresh_token:
token(id) | user_id | client_id | scopes
client
id | secret | avatar | display_name | dev_id
dev_account
username | password | id |// potentially user_id

individual_permissions (for front end)
scope_permissions_mapping

Pages:
Login (nice CRT vibe)
Manage Clients (user)

```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `oauth_implementation` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:oauth_implementation, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/oauth_implementation](https://hexdocs.pm/oauth_implementation).

