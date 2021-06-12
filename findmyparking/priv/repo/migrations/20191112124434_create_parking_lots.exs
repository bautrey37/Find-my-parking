defmodule Findmyparking.Repo.Migrations.CreateParkingLots do
  use Ecto.Migration

  def change do
    create table(:parking_lots) do
      add :name, :string
      add :latitude, :float
      add :longitude, :float
      add :total_spaces, :integer
      add :parking_zone, :string

      timestamps()
    end
  end
end
