defmodule FindmyparkingWeb.Authentication do
  alias Findmyparking.Guardian

  def check_credentials(user, plain_text_password) do
    if user && Pbkdf2.verify_pass(plain_text_password, user.hashed_password) do
      {:ok, user}
    else
      {:error, :unauthorized_user}
    end
  end

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end

  def logout(conn) do
    conn
    |> Guardian.Plug.sign_out()
  end

  def load_current_user(conn) do
    IO.puts "Am I authenticated?"
    IO.inspect Guardian.Plug.authenticated?(conn)
    conn
    |> Guardian.Plug.current_resource()
  end
end
