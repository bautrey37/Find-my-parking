defmodule FindmyparkingWeb.UserController do
  use FindmyparkingWeb, :controller
  import Ecto.Query, only: [from: 2]
  import Plug.Conn
  alias Findmyparking.{Repo, User, Allocation}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  # def fetchDetails(conn, _params) do
  #   allAllocations = fetchDetailsChild()

  #   conn
  #   |> put_status(200)
  #   |> json(allAllocations)
  # end

  def fetchDetailsChild() do
    IO.puts("Inside user controller")

    query =
      from a1 in Allocation,
        select: %{
          id: a1.id,
          parking_lot_id: a1.parking_lot_id,
          start_time: a1.start_time,
          end_time: a1.end_time,
          payment_status: a1.payment_status
        },
        where: a1.payment_type == "real", #TODO Ideally retrieving only from the logged in user
        order_by: [
          desc: a1.id
        ]

    allAllocations = Repo.all(query)

    allAllocations
  end

  def fetchDetailsAll() do
    IO.puts("Inside user controller")

    query =
      from a1 in Allocation,
        select: %{
          id: a1.id,
          parking_lot_id: a1.parking_lot_id,
          start_time: a1.start_time,
          end_time: a1.end_time,
          payment_status: a1.payment_status
        },
        order_by: [
          desc: a1.id
        ]

    allAllocations = Repo.all(query)

    allAllocations
  end

  def changePaymentStatus(aid) do
    # aid = params["aid"]
    # IO.puts("AID is")
    # IO.inspect(aid)


    # allocationId = Repo.get_by(Allocation, id: aid)
    # payment_status = allocationId.payment_status

    # if payment_status == "Paid" do
    #   conn
    #   |> put_status(406)
    #   |> json(%{msg: "The payment is already done"})
    # else
      allocationId = Repo.get_by(Allocation, id: aid)

      Repo.get_by(Allocation, id: aid)
      |> Ecto.Changeset.change(%{
        payment_status: "Paid"
      })
      |> Repo.update()

      # conn
      # |> put_status(200)
      # |> json(%{msg: "Payment Done"})
    # end
  end
end
