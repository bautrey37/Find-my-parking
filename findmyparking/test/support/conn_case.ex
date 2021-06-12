defmodule FindmyparkingWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias FindmyparkingWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint FindmyparkingWeb.Endpoint

      def send_request(conn) do
        conn
        |> put_private(:plug_skip_csrf_protection, true)
        |> FindmyparkingWeb.Endpoint.call([])
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Findmyparking.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Findmyparking.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
