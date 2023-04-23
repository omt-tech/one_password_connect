defmodule OnePassword.Connect.Section do
  @moduledoc """
  A way to categorize fields inside a vault item.
  Purely informational purposes and dumb data in this library
  and there is no functionality around it other than whatever you
  want to do yourself with it.
  """
  @type t :: %__MODULE__{
          id: String.t(),
          label: String.t() | nil
        }
  defstruct [
    :id,
    :label
  ]
end
