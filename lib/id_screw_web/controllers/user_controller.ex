defmodule IdScrewWeb.Session.UserController do
  use IdScrewWeb, :controller
  alias IdScrew.Save
  def create(conn, params) do
    IO.inspect(params)
    conn|>put_status(:ok) |> json(%{soma: 12})
  end

  def new_game_session(conn, params) do
    session_id = :rand.uniform(2000000);

    new_session = %{
      "game" => {},
      "players" => [
        %{
          "id" => "1",
          "name" => params["name"]
        }
      ]
    }
    Save.save(new_session, "12")
    conn|>put_status(:ok) |> json(%{soma: 12})
  end
end
