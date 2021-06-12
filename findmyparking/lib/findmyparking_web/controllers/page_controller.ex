defmodule FindmyparkingWeb.PageController do
  use FindmyparkingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
