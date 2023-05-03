defmodule OnePassword.Connect.Util do
  alias OnePassword.Connect.Vault

  @spec get_password(vault :: Vault.t(), item_name :: String.t()) ::
          {:ok, String.t()} | {:error, :not_found}
  def get_password(%Vault{items: items}, item_name) do
    Enum.find(items, %{}, fn item -> item.title == item_name end)
    |> Map.get(:fields, [])
    |> Enum.find({:error, :not_found}, fn field -> field.id == "password" end)
    |> then(fn
      {:error, err} ->
        {:error, err}

      res ->
        {:ok, res.value}
    end)
  end

  def get_password!(vault, item_name) do
    get_password(vault, item_name)
    |> case do
      {:error, _err} ->
        throw("Key #{item_name} not found in vault #{vault.name}")

      {:ok, value} ->
        value
    end
  end
end
