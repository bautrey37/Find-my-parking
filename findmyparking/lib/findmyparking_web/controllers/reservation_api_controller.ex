defmodule FindmyparkingWeb.ReservationAPIController do
  use FindmyparkingWeb, :controller
  import Plug.Conn
  alias Findmyparking.{Repo, ParkingLot, User}
  alias FindmyparkingWeb.Authentication

  @doc """
  Retrieves all the nearby parking lots from the parking_lot table.
  Excludes parking lots with no available spaces.
  """
  def retrieve_all_parking_lots(conn, _params) do
    all_parking_spaces = FindmyparkingWeb.ReservationController.retrieve_all_parking_lots()

    conn
    |> put_status(200)
    |> json(all_parking_spaces)
  end


  @doc """
  Retrieves the list of parking lots nearby to the address passed in.
  Returns http status of 200.
  """
  def retrieve_nearby_parking_lots(conn, _params) do
    # TODO: fix load current user
    #    user = Authentication.load_current_user(conn)
    user = Repo.get_by(User, username: "shaggy")

    filtered_parking_spaces =
      FindmyparkingWeb.ReservationController.retrieve_nearby_parking_lots(user)

    conn
    |> put_status(200)
    |> json(filtered_parking_spaces)
  end

  @doc """
  Decrements the rental space by 1.
  Called from the Booking button.
  """
  def book_space(conn, params) do
    IO.inspect(params)
    location_name = params["name"]
    payment_status = params["payment_status"]

    parking_lot = Repo.get_by(ParkingLot, name: location_name)
    total_spaces = parking_lot.total_spaces

    if total_spaces == 0 do
      conn
      |> put_status(406)
      |> json(%{msg: "This parking space is no more available bookings"})
    else
      # TODO: fix current user
      #      user = Authentication.load_current_user(conn)
      user = Repo.get_by(User, username: "shaggy")
      result = FindmyparkingWeb.ReservationController.book_space(user, location_name, payment_status)

      case result do
        {:ok, _} ->
          conn
          |> put_status(200)
          |> json(%{msg: "The space has been booked"})

        {:error, _} ->
          conn
          |> put_status(406)
          |> json(%{msg: "There is an error on saving the allocation"})
      end
    end
  end
end
