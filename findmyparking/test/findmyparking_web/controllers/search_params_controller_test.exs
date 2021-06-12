defmodule FindmyparkingWeb.SearchParamsControllerTest do
  use FindmyparkingWeb.ConnCase
  alias Findmyparking.{Repo, ParkingLot, User, Allocation}
  import FindmyparkingWeb.SearchParamsController

  setup do
    setup_user()
    |> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
  end

  defp setup_user do
    [
      %{
        name: "Testy Test",
        username: "test",
        password: "parool",
        search_address: "",
        search_start_time: ~N[2019-01-03 16:14:00.000],
        search_end_time: ~N[2019-01-03 18:14:00.000],
        search_billing_type: ""
      }
    ]
  end

  test "2.1 2.2 Search params" do
    user = Repo.get_by(User, username: "test")
    params =       
    %{
      "address" => "Juhan Liivi 2, Tartu, Tartumaa 50409, Estonia",
      "end_time" => "2019-12-09T01:01",
      "paymentType" => "hourly",
      "start_time" => "2019-12-09T00:01",
      "username" => "test"
    }

    expected =
      %{
        search_address: "Juhan Liivi 2, Tartu, Tartumaa 50409, Estonia",
        search_end_time: ~N[2019-12-09 01:01:00],
        search_payment_type: "hourly",
        search_start_time: ~N[2019-12-09 00:01:00],
        username: "test"
      }
    
    storeParams("", params)
    user = Repo.get_by(User, username: "test")

    assert user.search_start_time == expected.search_start_time
    assert user.search_end_time == expected.search_end_time
    assert user.search_billing_type == expected.search_payment_type
  end
end
