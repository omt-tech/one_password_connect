defmodule OnePassword.Connect.Configuration do
  @moduledoc """
  This module takes the configuration for a request to a connect server and
  is the main way to use a `OnePassword.Connect.Client`.

  *base_vault_url* is where to find the server and much be reachable as a http request.
  Samples include:
  - https://myconnectserver.corporatedomain.com
  - http://localhost:8090
  - localhost:8090
  - https://localhost:4443
  And so on...

  If url contains "https" and *skip_ssl_check* is not truthy (defaults to false)
  the ssl certificate will be validated. If you are using self signed certs on
  internal private networks and you are not worried about MITM attacks etc.

  Add configurations and use them with clients as needed to retrieve configuration you are after.

  The `vaults` entry is a list where each entry
  takes either a String with a vault name of a tuple of vault name and
  a list of fields.

  The minimum required config in `vaults` is a list with one string
  `"sample vault"` which will fetch all entries in `sample vault`.

  The initial vault list that always fires only fetches metadata like the
  name etc so the overhead of fetching an item is one more HTTP request per item.

  Generally the api from 1Password and thesystem is created to support hammering so unless you have a
  truly massive vault you should not worry too much about the extra requests needed
  if you have a couple of items you don't care about.

  Multiple vaults with the same name is undefined behaviour and it will simply pick the first one.
  Future release will let you specify a `{:with_id, vault_id_string, _items}` entry instead of name based.
  """

  @type t :: %__MODULE__{
          token: String.t(),
          base_vault_url: String.t(),
          skip_ssl_check: true | false | nil,
          vaults: [{String.t(), [String.t()]} | String.t()]
        }
  defstruct [
    :token,
    :base_vault_url,
    {:skip_ssl_check, false},
    :vaults
  ]

  def new(map) do
    # Atomize keys
    config =
      Enum.reduce(map, %{}, fn {key, val}, acc ->
        Map.put(acc, String.to_existing_atom(key), val)
      end)

    cond do
      is_nil(config.token) || config.token == "" ->
        throw("Invalid config - missing token")

      is_nil(config.base_vault_url) || config.base_vault_url == "" ->
        throw("Invalid config - missing base url")

      true ->
        struct(__MODULE__, config)
    end
  end
end
