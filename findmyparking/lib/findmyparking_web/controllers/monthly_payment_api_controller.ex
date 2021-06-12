defmodule FindmyparkingWeb.MonthlyPaymentAPIController do
  use FindmyparkingWeb, :controller
  import Ecto.Query, only: [from: 2]
  import Plug.Conn
  alias Findmyparking.{Repo, User, Allocation}

  def fetchMonthlyDetails(conn, _params) do
    allAllocations = FindmyparkingWeb.MonthlyPaymentController.fetchMonthlyDetails();

    conn
    |> put_status(200)
    |> json(allAllocations)
  end


  def changePaymentStatus(conn, params) do
    a_ids = params["a_ids"]
    IO.puts("AID is")
    IO.inspect(a_ids)

#    allocations = from(a in Allocation, where: a.id in ^a_ids) |> Repo.all
#    IO.inspect allocations
    result = FindmyparkingWeb.MonthlyPaymentController.changePaymentStatus(a_ids);
    IO.inspect result
    conn
    |> put_status(200)
    |> json(%{msg: "Payment Done"})

  end

end
