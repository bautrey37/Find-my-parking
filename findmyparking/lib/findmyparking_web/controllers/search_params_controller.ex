defmodule FindmyparkingWeb.SearchParamsController do
  use FindmyparkingWeb, :controller
  import Ecto.Query, only: [from: 2]
  import Plug.Conn
  alias Findmyparking.{Repo, User, ParkingLot}
  alias FindmyparkingWeb.Authentication

  @doc """
  Stores search params.
  Called from the Main page.
  """
  def storeParams(conn, params) do
    IO.inspect(params)
    address = params["address"]
    start_time = params["start_time"]
    start_time = "#{start_time}:00"
    start_time = elem(NaiveDateTime.from_iso8601(start_time), 1)
    end_time = params["end_time"]
    end_time = "#{end_time}:00"
    end_time = elem(NaiveDateTime.from_iso8601(end_time), 1)
    name = params["username"]
    payment_type = params["paymentType"]

    IO.inspect(name)
    IO.inspect(start_time)
    IO.inspect(address)
    IO.inspect(start_time)
    IO.inspect(payment_type)

    Repo.get_by(User, username: name)
    |> Ecto.Changeset.change(%{
      search_address: address,
      search_start_time: start_time,
      search_end_time: end_time,
      search_billing_type: payment_type
    })
    |> Repo.update()

    if conn != "" do
      conn
      |> put_status(200)
      |> json(%{msg: "The params have been stored"})
    end
  end

  def getPaymentType(conn, _params) do
    query =
      from user in User,
        select: %{
          search_billing_type: user.search_billing_type
        },
        where: user.username == "shaggy"

    query_resp = Repo.all(query)
    payment_type = List.first(query_resp).search_billing_type

    conn
    |> put_status(200)
    |> json(payment_type)
  end
end
