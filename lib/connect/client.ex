defmodule OnePassword.Connect.Client do
  alias OnePassword.Connect.{
    Configuration,
    Vault,
    VaultItem
  }

  def fetch(%Configuration{vaults: vaults} = config) do
    Enum.reduce(vaults, %{}, fn
      {vault_name, items}, acc ->
        vault = fetch_vault(config, vault_name)
        Map.put(acc, vault.name, fetch_items(config, vault, items))

      vault_name, acc ->
        vault = fetch_vault(config, vault_name)
        Map.put(acc, vault.name, fetch_items(config, vault, nil))
    end)
  end

  defp fetch_vault(config, name) do
    query =
      URI.encode_query(%{
        filter: "name eq \"#{name}\""
      })

    url = String.to_charlist(config.base_vault_url) ++ '/v1/vaults?' ++ String.to_charlist(query)

    :httpc.request(:get, {url, headers(config)}, ssl_request_opts(config), [])
    |> unpack_get()
    # |> IO.inspect(label: "Vault fetch")
    |> List.first()
    |> Vault.from_raw()
  end

  defp fetch_items(config, %Vault{id: vault_id} = vault, item_filter) do
    url =
      String.to_charlist(config.base_vault_url) ++
        '/v1/vaults/' ++ String.to_charlist(vault_id) ++ '/items'

    :httpc.request(:get, {url, headers(config)}, ssl_request_opts(config), [])
    |> unpack_get()
    # |> IO.inspect(label: "Item list fetch")
    |> filter_items(item_filter)
    |> Enum.reduce(vault, fn raw_item, %Vault{items: items} = acc ->
      acc_items = [
        fetch_item_data(config, vault, raw_item["id"])
        | items
      ]

      %{acc | items: acc_items}
    end)
  end

  defp filter_items(raw_items, nil), do: raw_items

  defp filter_items(raw_items, item_filter) do
    Enum.filter(raw_items, fn %{"title" => title} -> title in item_filter end)
  end

  defp fetch_item_data(config, %Vault{id: vault_id}, item_id) do
    url =
      String.to_charlist(config.base_vault_url) ++
        '/v1/vaults/' ++ String.to_charlist(vault_id) ++ '/items/' ++ String.to_charlist(item_id)

    :httpc.request(:get, {url, headers(config)}, ssl_request_opts(config), [])
    |> unpack_get()
    # |> IO.inspect(label: "Item details fetch")
    |> VaultItem.from_raw()
  end

  defp headers(%Configuration{token: token}) do
    [
      {
        'authorization',
        String.to_charlist("Bearer #{token}")
      },
      {'accept', 'application/json'}
    ]
  end

  defp ssl_request_opts(%Configuration{skip_ssl_check: false}) do
    [ssl: :httpc.ssl_verify_host_options(false)]
  end

  defp ssl_request_opts(_), do: []

  def unpack_get({:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, json_payload}}) do
    Jason.decode!(json_payload)
  end
end
