defmodule IdScrew.Player do
  use Ecto.Schema

  embedded_schema do
    field :name, :string
    field :points, :integer
    field :ready, :boolean
  end
end
