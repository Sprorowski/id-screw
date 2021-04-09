defmodule IdScrew.Save do
  def save(session, id) do
    IO.inspect(session)
    {:ok, body} = File.read("game.json")
    {:ok, base} = Poison.decode(body)
    {:ok, file} = File.open("teste.json", [:write])
    base = base["sessions"] |> Map.put(id, session)
    IO.inspect(base)
    IO.write(file, Poison.encode!(base))
  end

  def find_session(session_id) do
    with {:ok, body} <- File.read("game.json"),
         {:ok, %{"sessions" => %{^session_id => session}}} <- Poison.decode(body) do
      {:ok, session}
    else
      _ -> {:error, :session_not_found}
    end
  end

  def find_player_session(session, player_id) do

  end

  def ready(session_id, player) do
    session_id |> find_session |> players |> IO.inspect
    # |> Enum.with_index() |>  Enum.each(fn {player_b, idx} -> IO.inspect(player_b)  end )
    {:ok}
  end

  def players({:ok, %{"players" => players}}) do
    {:ok, players}
  end

  def save_player(player, session_id) do
    {:ok, session} = find_session(session_id)
    session["players"] |> Enum.map(fn {} -> end)

    players = session["players"] ++ [player]
    session |> Map.put("players", players) |> save_session(session_id)
  end

  def save_session(session, session_id) do
    IO.inspect(session)
    {:ok, body} = File.read("game.json")
    {:ok, base} = Poison.decode(body)
    {:ok, file} = File.open("game.json", [:write])
    base = base |> Map.put("sessions", base["sessions"] |> Map.put(session_id, session))
    file |> IO.write( Poison.encode!(base))
    {:ok}
  end
end
