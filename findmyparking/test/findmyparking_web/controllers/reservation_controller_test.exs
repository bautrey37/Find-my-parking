defmodule FindmyparkingWeb.ReservationControllerTest do
  use FindmyparkingWeb.ConnCase
  alias Findmyparking.{Repo, ParkingLot, User, Allocation}
  import FindmyparkingWeb.ReservationController

  setup do
    setup_all_parking_lots()
    |> Enum.map(fn parkinglot_data -> ParkingLot.changeset(%ParkingLot{}, parkinglot_data) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)

    setup_user()
    |> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
  end

  defp setup_all_parking_lots do
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
        total_spaces: 3,
        parking_zone: "B"
      },
      %{
        name: "Õpetaja 9",
        latitude: 58.374823,
        longitude: 26.716418,
        total_spaces: 0,
        parking_zone: "B"
      }
    ]
  end

  defp setup_user do
    [
      %{
        name: "Testy Test",
        username: "test",
        password: "parool",
        search_address: "Ülikooli 18, Tartu, Estonia",
        search_start_time: ~N[2019-12-03 16:14:00.000],
        search_end_time: ~N[2019-12-03 18:14:00.000],
        search_billing_type: "hourly"
      }
    ]
  end

  @doc """
  Retrieves all the parking spaces from the parking_lots table.
  If a spot has 0 total spaces, then it is not retrieved.
  """
  test "retrieve all parking spaces" do
    all_parking_lots =
      retrieve_all_parking_lots()
      |> Enum.sort()

    expected =
      setup_all_parking_lots()
      |> Enum.filter(fn item -> item.total_spaces > 0 end)
      |> Enum.sort()

    assert all_parking_lots == expected
  end

  test "retrieve nearby parking spaces; Ülikooli 18, 51005 Tartu, Estonia" do
    user = Repo.get_by(User, username: "test")
    nearby_parking_spaces = retrieve_nearby_parking_lots(user)

    expected = [
      %{
        latitude: 58.382177,
        longitude: 26.717216,
        name: "Lai 7",
        parking_zone: "A",
        price: 4,
        total_spaces: 5
      },
      %{
        latitude: 58.38361,
        longitude: 26.719252,
        name: "Lai 30",
        parking_zone: "A",
        price: 4,
        total_spaces: 20
      }
    ]

    assert nearby_parking_spaces == expected
  end

  test "when booking space, appropriate allocation is committed" do
    user = Repo.get_by(User, username: "test")
    book_space(user, "Lai 7", "Not Paid")

    allocations = FindmyparkingWeb.UserController.fetchDetailsAll()

    IO.inspect(allocations)
    IO.inspect(List.last(allocations).payment_status)
    assert List.last(allocations).payment_status == "Not Paid"
  end

  test "3.1 prepay for space" do
    user = Repo.get_by(User, username: "test")
    book_space(user, "Lai 7", "Paid")

    allocations = FindmyparkingWeb.UserController.fetchDetailsAll()

    IO.inspect(allocations)
    IO.inspect(List.last(allocations).payment_status)
    assert List.last(allocations).payment_status == "Paid"
  end
end
