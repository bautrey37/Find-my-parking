defmodule FindmyparkingWeb.MonthlyPaymentControllerTest do
  use FindmyparkingWeb.ConnCase
  import Ecto.Query, only: [from: 2]
  alias Findmyparking.{Repo, Allocation, ParkingLot, User}
  import FindmyparkingWeb.MonthlyPaymentController

  setup do
    setup_all_parking_lots()
    |> Enum.map(fn parkinglot_data -> ParkingLot.changeset(%ParkingLot{}, parkinglot_data) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)

    setup_user()
    |> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)

    parking_lot = Repo.get_by(ParkingLot, name: "Lai 7")
    user = Repo.get_by(User, username: "test")

    setup_allocations(user, parking_lot)
    |> Enum.map(fn allocation_data -> Allocation.changeset(%Allocation{}, allocation_data) end)
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
        search_billing_type: "real"
      }
    ]
  end

  defp setup_allocations(user, parking_lot) do
    [
      %{
        user_id: user.id,
        parking_lot_id: parking_lot.id,
        start_time: ~N[2019-12-03 16:14:00],
        end_time: ~N[2019-12-03 18:14:00],
        payment_type: "real",
        payment_status: "Not Paid"
      },
      %{
        user_id: user.id,
        parking_lot_id: parking_lot.id,
        start_time: ~N[2019-12-03 16:14:00.000],
        end_time: ~N[2019-12-03 18:14:00.000],
        payment_type: "hourly",
        payment_status: "Paid"
      },
      %{
        user_id: user.id,
        parking_lot_id: parking_lot.id,
        start_time: ~N[2019-12-03 16:14:00.000],
        end_time: ~N[2019-12-03 18:14:00.000],
        payment_type: "hourly",
        payment_status: "Not Paid"
      },
      %{
        user_id: user.id,
        parking_lot_id: parking_lot.id,
        start_time: ~N[2019-12-03 16:14:00.000],
        end_time: ~N[2019-12-03 18:14:00.000],
        payment_type: "real",
        payment_status: "Paid"
      }
    ]
  end

  test "fetchMonthlyDetails" do
    result =
      fetchMonthlyDetails()
      |> Enum.map(fn data -> Map.drop(data, [:id, :parking_lot_id]) end)

    expected = [
      %{
        end_time: ~N[2019-12-03 18:14:00],
        payment_status: "Not Paid",
        start_time: ~N[2019-12-03 16:14:00]
      }
    ]

    assert result == expected
  end

  test "changePaymentStatus" do
    query =
      from (a in Allocation), where: a.payment_type == "real" and a.payment_status == "Not Paid"

    allocation_ids =
      Repo.all(query)
      |> Enum.map(fn data -> data.id end)

    result = changePaymentStatus(allocation_ids)
    expected = {1, nil}

    assert result == expected
  end

  test "changePaymentStatus; none to update" do
    result = changePaymentStatus([])
    expected = {0, nil}

    assert result == expected
  end

end