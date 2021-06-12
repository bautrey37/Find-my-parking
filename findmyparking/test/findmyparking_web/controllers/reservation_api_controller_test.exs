defmodule FindmyparkingWeb.ReservationAPIControllerTest do
  use FindmyparkingWeb.ConnCase
  use ExUnit.Case
  import Ecto.Query, only: [from: 2]
  alias Findmyparking.{Repo, ParkingLot}

  setup do
    [
      %{
        name: "Lai 7",
        latitude: 58.382177,
        longitude: 26.717216,
        total_spaces: 5,
        parking_zone: "A"
      },
      %{
        name: "Lai 30",
        latitude: 58.383610,
        longitude: 26.719252,
        total_spaces: 20,
        parking_zone: "A"
      },
      %{
        name: "Tiigi 61",
        latitude: 58.374380,
        longitude: 26.711739,
        total_spaces: 10,
        parking_zone: "B"
      },
      %{
        name: "Õpetaja 9",
        latitude: 58.374823,
        longitude: 26.716418,
        total_spaces: 50,
        parking_zone: "B"
      }
    ]
    |> Enum.map(fn parkinglot_data -> ParkingLot.changeset(%ParkingLot{}, parkinglot_data) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
  end

  @tag :skip
  test "update spaces", %{conn: _conn} do
    ## query to get parking lot available spaces
    query = from pl in ParkingLot, where: pl.name == "Lai 7", select: pl
    [t1 | _] = Repo.all(query)
    original_total_spaces = t1.total_spaces
    assert original_total_spaces > 0

    ## Calling the api for a reservation on Lai 7's parking
    patch(build_conn(), "api/reservation", name: "Lai 7")

    ## query to confirm that the parking lot available spaces was decremented by 1
    query = from pl in ParkingLot, where: pl.name == "Lai 7", select: pl
    [t1 | _] = Repo.all(query)
    updated_total_spaces = t1.total_spaces
    ## Checking the difference
    assert original_total_spaces - updated_total_spaces == 1
  end

  @tag :skip
  test "retrieve parking lots", %{conn: _conn} do
    response = conn(:get, "/api/reservation") |> send_request

    assert response.status == 200
  end
end
