defmodule Findmyparking.ParkingLot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parking_lots" do
    field :name, :string
    field :latitude, :float
    field :longitude, :float
    field :total_spaces, :integer
    field :parking_zone, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :latitude, :longitude, :total_spaces, :parking_zone])
    |> validate_required([:name, :latitude, :longitude, :total_spaces, :parking_zone])
    |> unique_constraint(:name)
  end
end
