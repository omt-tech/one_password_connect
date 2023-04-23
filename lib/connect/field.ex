defmodule OnePassword.Connect.Field do
  @moduledoc """
  Onepassword labels "username", "password" and "notes" as _purpose_ instead
  of type which it uses for all the other fields.

  This library simply conflates all of these into the `type` field.
  """

  @type t :: %__MODULE__{
          id: String.t(),
          type: String.t(),
          label: String.t() | nil,
          value: String.t() | nil
        }
  defstruct [
    :id,
    :type,
    :label,
    :value
  ]

  def from_raw(map) do
    %__MODULE__{
      id: map["id"],
      type: map["type"] || map["purpose"],
      label: map["label"],
      value: map["value"]
    }
  end
end
