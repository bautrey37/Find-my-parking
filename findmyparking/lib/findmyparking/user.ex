defmodule Findmyparking.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :search_address, :string
    field :search_start_time, :naive_datetime
    field :search_end_time, :naive_datetime
    field :search_billing_type, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :name,
      :username,
      :password,
      :search_address,
      :search_start_time,
      :search_end_time,
      :search_billing_type
    ])
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
    |> validate_length(:password, min: 6)
    |> hash_password
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end
