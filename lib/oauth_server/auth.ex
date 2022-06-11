defmodule OAuthServer.Auth do

  @spec validate_callback(String.t(), String.t()) :: :ok, {:error, atom()}
  def validate_callback(client_id, callback_url) do
    # TODO: ensure that the query params don't ruin things
    :ok
  end
end
