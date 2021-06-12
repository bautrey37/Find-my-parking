defmodule FindmyparkingWeb.PageControllerTest do
  use FindmyparkingWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Find My Parking Application"
  end
end
