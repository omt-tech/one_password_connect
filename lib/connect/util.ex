defmodule OnePassword.Connect.Util do
  alias OnePassword.Connect.Vault

  def get_password(%Vault{items: items}, item_name) do
    Enum.find(items, %{}, fn item -> item.title == item_name end)
    |> Map.get(:fields, [])
    |> Enum.find("", fn field -> field.type == "password" end)
  end
end
