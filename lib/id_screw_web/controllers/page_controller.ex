defmodule IdScrewWeb.PageController do
  use IdScrewWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
