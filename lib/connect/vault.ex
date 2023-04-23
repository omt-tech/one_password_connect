defmodule OnePassword.Connect.Vault do
  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          items: [VaultItem.t()] | nil
        }
  defstruct [
    :id,
    :name,
    :items
  ]

  def from_raw(map) do
    %__MODULE__{
      id: map["id"],
      name: map["name"],
      items: []
    }
  end
end
