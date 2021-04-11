defmodule IdScrew.Session do
  use Ecto.Schema
  import Ecto.Changeset

  alias IdScrew.Player

  @primary_key false
  embedded_schema do
    embeds_many :players, Player
  end

  def changeset_applied(session, attrs \\ %{}) do
    session
    |> cast_assoc(attrs, :players)
    |> apply_changes()
  end
end
