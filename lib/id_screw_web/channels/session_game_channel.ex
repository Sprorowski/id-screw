defmodule IdScrewWeb.SessionGameChannel do
  use IdScrewWeb, :channel

  alias IdScrew.Save

  @impl true
  def join("session_game:lobby", payload, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # @impl true
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (session_game:lobby).
  @impl true
  @spec handle_in(<<_::40>>, any, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_in("shout", payload, socket) do
    pl = if payload["id"] == nil do
      payload|> Map.put("id", :rand.uniform(99999))
    else
      payload
    end
    IO.inspect(pl)
    broadcast socket, "shout", pl
    {:noreply, socket}
  end

  @impl true
  def handle_in("enter", payload, socket) do
    IO.inspect(socket)
    new_player = %{"id"=> payload["id"], "name" => payload["name"], "points" => 5,"ready" => false}
    Save.save_player(new_player, "12")

    {:ok, players}  = "12" |> Save.find |> Save.players
    payl = payload |> Map.put("player", players)
    broadcast socket, "players", payl
    {:noreply, socket}
  end

  @impl true
  def handle_in("ready", payload, socket) do
    IO.inspect(payload)
    session = Save.ready("12", 51021)

    IO.inspect(session)
    broadcast socket, "ready", payload
    {:noreply, socket}
  end
  def handle_in("players", payload, socket) do
    {:ok, players}  = "12" |> Save.find |> Save.players
    payl = payload |> Map.put("player", players)
    broadcast socket, "players", payl
  end
end
