defmodule FindmyparkingWeb.ReservationController do
  use FindmyparkingWeb, :controller
  import Ecto.Query, only: [from: 2]
  import FindmyparkingWeb.Geolocation
  import FindmyparkingWeb.Pricing
  alias Ecto.{Multi}
  alias Findmyparking.{Repo, ParkingLot, Allocation}

  @doc """
  Renders the reservation index.html page
  """
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
  Retrieves all the parking lots from the parking_lot table.
  Excludes parking lots with no available spaces.
  """
  def retrieve_all_parking_lots() do
    query =
      from pl in ParkingLot,
        select: %{
          name: pl.name,
          total_spaces: pl.total_spaces,
          latitude: pl.latitude,
          longitude: pl.longitude,
          parking_zone: pl.parking_zone
        },
        where: pl.total_spaces > 0,
        order_by: [
          desc: pl.name
        ]

    allParkingSpaces = Repo.all(query)
    allParkingSpaces
  end

  @doc """
  Finds how many free spaces are in a parking lot for a given time
  """
  def filter_parking_spaces_by_times(parking_spaces) do
    parking_spaces
    |> Enum.with_index()
    |> Enum.each(fn {x, i} ->
      nil
      # IO.puts("#{i} => #{x}")
    end)

    parking_spaces
  end

  @doc """
  Retrieves the list of parking lots nearby to the address passed in.
  Default distance of nearby is 1.5 km.
  """
  def retrieve_nearby_parking_lots(user) do
    IO.puts "User: "
    IO.inspect user
    default_distance = 1.5
    address = user.search_address

    [latitude, longitude] = find_location(address)

    filtered_parking_spaces =
      retrieve_all_parking_lots()
      |> Enum.filter(fn x ->
        d1 = distance(latitude, longitude, x.latitude, x.longitude)
        d1 <= default_distance
      end)
      |> append_calculate_price(user)

    # filtered_parking_spaces = filter_parking_spaces_by_times(filtered_parking_spaces)

    IO.puts("Filtered parking spaces:")
    IO.inspect(filtered_parking_spaces)
    filtered_parking_spaces
  end

  def append_calculate_price(parking_lots, user) do
    parking_lots
    |> Enum.map(fn x ->
      result =
        calculate_price(
          x.parking_zone,
          user.search_start_time,
          user.search_end_time,
          user.search_billing_type
        )

      case result do
        {:ok, value} -> Map.merge(x, %{price: value})
        {:error, _} -> x
      end
    end)
  end

  @doc """
  Create a new allocation with links to user and packing lot tables.
  Updates the parking lot total space to decrement by 1
  """
  def book_space(user, location_name, payment_status) do
    IO.inspect("Entering reservation controller")
    IO.inspect(user)

    parking_lot = Repo.get_by(ParkingLot, name: location_name)
    IO.inspect(parking_lot)
    left_spaces = parking_lot.total_spaces - 1

    result =
      Multi.new()
      |> Multi.insert(
        :allocation,
        Allocation.changeset(
          %Allocation{},
          %{
            start_time: user.search_start_time,
            end_time: user.search_end_time,
            payment_type: user.search_billing_type,
            user_id: user.id,
            parking_lot_id: parking_lot.id,
            payment_status: payment_status
          }
        )
      )
      |> Multi.update(
        :parkinglot,
        ParkingLot.changeset(parking_lot, %{total_spaces: left_spaces})
      )
      |> Repo.transaction()

    IO.inspect(result)
    result
  end
end
