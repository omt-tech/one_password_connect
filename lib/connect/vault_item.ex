defmodule OnePassword.Connect.VaultItem do
  alias OnePassword.Connect.{
    Field
    #  Section
  }

  @type t :: %__MODULE__{
          id: String.t(),
          title: String.t(),
          # tags: [String.t()] | nil,
          category: String.t(),
          # sections: [Section.t()] | nil,
          fields: [Field.t()] | []
        }
  defstruct [
    :id,
    :title,
    # :tags,
    :category,
    # :sections,
    :fields
  ]

  def from_raw(map) do
    %__MODULE__{
      id: map["id"],
      title: map["title"],
      category: map["category"],
      fields:
        Enum.reduce(map["fields"] || [], [], fn raw_field, acc ->
          [
            Field.from_raw(raw_field)
            | acc
          ]
        end)
    }
  end
end
