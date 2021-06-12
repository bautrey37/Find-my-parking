defmodule FindmyparkingWeb.MonthlyPaymentController do
  use FindmyparkingWeb, :controller
  import Ecto.Query, only: [from: 2]
  import Plug.Conn
  alias Findmyparking.{Repo, User, Allocation}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def fetchMonthlyDetails() do
    query =
      from a1 in Allocation,
        select: %{
          id: a1.id,
          parking_lot_id: a1.parking_lot_id,
          start_time: a1.start_time,
          end_time: a1.end_time,
          payment_status: a1.payment_status
        },
        where: a1.payment_type == "real" and a1.payment_status == "Not Paid",
        order_by: [
          desc: a1.id
        ]

    Repo.all(query)
  end

  def changePaymentStatus(a_ids) do
    query = from(a in Allocation, where: a.id in ^a_ids)

    result = Repo.update_all(
      query,
      set: [
        payment_status: "Paid"
      ]
    )
    result
  end

end
