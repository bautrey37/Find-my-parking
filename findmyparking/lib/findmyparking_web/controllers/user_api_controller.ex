defmodule FindmyparkingWeb.UserAPIController do
  use FindmyparkingWeb, :controller
  import Ecto.Query, only: [from: 2]
  import Plug.Conn
  alias Findmyparking.{Repo, User, Allocation}


  def fetchDetails(conn, _params) do
    allAllocations = FindmyparkingWeb.UserController.fetchDetailsChild();

    conn
    |> put_status(200)
    |> json(allAllocations)
  end


  def changePaymentStatus(conn, params) do
    aid = params["aid"]
    # IO.puts("AID is")
    # IO.inspect(aid)

    allocationId = Repo.get_by(Allocation, id: aid)
    payment_status = allocationId.payment_status
    # end_time = allocationId.end_time

    if payment_status == "Paid" do
      conn
      |> put_status(406)
      |> json(%{msg: "The payment is already done"})
    else
    FindmyparkingWeb.UserController.changePaymentStatus(aid);
    conn
      |> put_status(200)
      |> json(%{msg: "Payment Done"})
    end
  end
end
