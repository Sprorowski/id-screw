defmodule IdScrew.Game do
  def new_game() do
    %{
       "playing" => true,
       "round_count" => 1,
       "rounds" => nil
     }
  end
end
