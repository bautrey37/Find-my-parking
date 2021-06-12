defmodule FindmyparkingWeb.UserControllerTest do
  use FindmyparkingWeb.ConnCase
  import Ecto.Query, only: [from: 2]
  alias Findmyparking.{Repo, Allocation, ParkingLot, User}
  import FindmyparkingWeb.UserController

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

  @doc """
  Verifies that the function retrives the correct allocations and there details.
  """
  test "retrieve allocations" do
    allocations = FindmyparkingWeb.UserController.fetchDetailsChild()
    # [allocation_one | _] = allocations

    expected = [
      %{
        start_time: ~N[2019-12-03 16:14:00],
        end_time: ~N[2019-12-03 18:14:00],
        payment_status: "Paid"
      },

      %{
        start_time: ~N[2019-12-03 16:14:00],
        end_time: ~N[2019-12-03 18:14:00],
        payment_status: "Not Paid"
      }  
    ]

    [first | [second]] = expected
    [first_al | [second_al]] = allocations

    assert first.start_time == first_al.start_time
    assert first.end_time == first_al.end_time
    assert first.payment_status == first_al.payment_status

    assert second.start_time == second_al.start_time
    assert second.end_time == second_al.end_time
    assert second.payment_status == second_al.payment_status

  end

  @doc """
  Verifies that the function retrives the correct allocations and there details.
  """
  test "test status change" do

    query =
      from al in Allocation,
        select: %{
          id: al.id,
          payment_status: al.payment_status
        },
        where: al.payment_status == "Not Paid"

    allocation = Repo.all(query)

    [first | tail] = allocation

    target_id = first.id
    target_payment_status = first.payment_status

    assert target_payment_status == "Not Paid"

    # IO.puts("HEEEEERE")
    # IO.inspect(allocation)
    # IO.inspect(target_id)

    FindmyparkingWeb.UserController.changePaymentStatus(target_id)

    query =
      from al in Allocation,
        select: %{
          payment_status: al.payment_status
        },
        where: al.id == ^target_id #TODO change the int with the real id of the allocation (ie: target_id)

    allocation = Repo.all(query)

    [first | tail] = allocation

    assert first.payment_status == "Paid"

  end

end
