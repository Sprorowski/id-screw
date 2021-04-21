defmodule IdScrew.Rules do
  @deck [
    "4O",
    "4E",
    "4C",
    "4P",
    "5O",
    "5E",
    "5C",
    "5P",
    "6O",
    "6E",
    "6C",
    "6P",
    "7O",
    "7E",
    "7C",
    "7P",
    "QO",
    "QE",
    "QC",
    "QP",
    "JO",
    "JE",
    "JC",
    "JP",
    "KO",
    "KE",
    "KC",
    "KP",
    "AO",
    "AE",
    "AC",
    "AP",
    "2O",
    "2E",
    "2C",
    "2P",
    "3O",
    "3E",
    "3C",
    "3P"
  ]

  def validate(:bet, uid, bet) do
  end

  def validate(:play, uid, card) do
  end

  def do_hands(players, n_rounds) do
    cards_need = Enum.count(players) |> Kernel.*(n_rounds)
    rand_cards = (cards_need + 1) |> rand_numbers |> Enum.chunk_every(cards_need)
    hands = rand_cards |> Enum.at(0) |> Enum.chunk_every(n_rounds)

    resp_hands =
      players
      |> Enum.with_index()
      |> Enum.map(fn {player, index} ->
        %{"player_id" => player["id"], "hand" => Enum.at(hands, index)}
      end)
    {resp_hands, rand_cards |> Enum.at(1)}
  end

  defp rand_numbers(numbers) do
    Enum.take_random(1..40, numbers)
  end
end
