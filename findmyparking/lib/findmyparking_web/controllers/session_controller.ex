defmodule FindmyparkingWeb.SessionController do
  use FindmyparkingWeb, :controller

  alias FindmyparkingWeb.Authentication
  alias Findmyparking.{Repo, User}


  @doc """
  Render the session page
  """
  def new(conn, _params) do
    render(conn, "new.html")
  end

  @doc """

  """
  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    user = Repo.get_by(User, username: username)
    IO.puts "session controller: create"
    IO.inspect user

    case Authentication.check_credentials(user, password) do
      {:ok, _} ->
        conn
        |> Authentication.login(user)
        |> put_flash(:info, "Welcome #{username}")
        |> redirect(to: page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Bad User Credentials")
        |> render("new.html")
    end
  end

  @doc """

  """
  def delete(conn, _params) do
    conn
    |> Authentication.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
