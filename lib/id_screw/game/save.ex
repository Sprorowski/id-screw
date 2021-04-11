defmodule IdScrew.Save do
  alias IdScrew.Session

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
    session_id |> find_session |> players |> IO.inspect()
    # |> Enum.with_index() |>  Enum.each(fn {player_b, idx} -> IO.inspect(player_b)  end )
    {:ok}
  end

  def players({:ok, %{"players" => players}}) do
    {:ok, players}
  end

  def save_player(player, session_id) do
    {:ok, %{"players" => players} = session} = find_session(session_id)

    players =
      players
      |> Enum.map(&maybe_update_player(&1, player))
      |> Enum.concat([player])

    %Session{}
    |> Session.changeset_applied(%{players: players})
    |> save_session(session_id)
  end

  def save_session(%Session{} = session, session_id) do
    IO.inspect(session)
    {:ok, body} = File.read("game.json")
    {:ok, base} = Poison.decode(body)
    {:ok, file} = File.open("game.json", [:write])
    base = base |> Map.put("sessions", base["sessions"] |> Map.put(session_id, session))
    file |> IO.write(Poison.encode!(base))
    {:ok}
  end

  defp maybe_update_player(%{"id" => player_id}, %{"id" => new_player_id} = new_player)
       when player_id == new_player_id do
    new_player
  end

  defp maybe_update_player(player, _), do: player
end
