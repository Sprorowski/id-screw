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

  @spec find_player_session({:ok, map}, any) :: any
  def find_player_session({:ok, %{"players" => players}}, player_id) do
    players |> Enum.filter(&player_found(&1, player_id)) |> Enum.at(0)
  end

  def ready(session_id, player_id) do
    session = session_id |> find_session

    session
    |> find_player_session(player_id)
    |> Map.put("ready", true)
    |> IO.inspect()
    |> save_player(session_id)

    {:ok, session}
  end

  def players({:ok, %{"players" => players}}) do
    {:ok, players}
  end

  def save_player(player, session_id) do
    {:ok, %{"players" => players} = session} = find_session(session_id)

    players =
      players
      |> Enum.filter(&maybe_update_player(&1, player))
      |> Enum.concat([player])

    session |> Map.put("players", players) |> save_session(session_id)
  end

  def save_session(%{} = session, session_id) do
    {:ok, body} = File.read("game.json")
    {:ok, base} = Poison.decode(body)
    {:ok, file} = File.open("game.json", [:write])
    base = base |> Map.put("sessions", base["sessions"] |> Map.put(session_id, session))
    file |> IO.write(Poison.encode!(base))
    {:ok}
  end

  defp player_found(%{"id" => player_id}, get_player_id) do
    player_id == get_player_id
  end

  defp maybe_update_player(%{"id" => player_id}, %{"id" => new_player_id})
       when player_id == new_player_id do
    false
  end

  defp maybe_update_player(player, _), do: true

  def save_game(game, session_id) do
    {:ok, %{"games" => games} = session} = find_session(session_id) |> IO.inspect
    games =
      games
      |> Enum.filter(&maybe_update_game(&1))
      |> Enum.concat([game])
    session |> Map.put("games", games)|> IO.inspect |> save_session(session_id)
  end

  defp maybe_update_game(%{"playing" => playing}) when playing do
    false
  end

  defp maybe_update_game(game), do: true
end
