# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
# or  mix ecto.seed
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Findmyparking.Repo.insert!(%Findmyparking.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Findmyparking.DatabaseSeederDev do
  alias Findmyparking.{Repo, User, ParkingLot}
  import Ecto.Query

  def seed_data() do
    clear_data()
    insert_users()
    insert_parkinglots()
  end

  def clear_data() do
    from(pl in ParkingLot, select: pl) |> Repo.delete_all()
    from(u in User, select: u) |> Repo.delete_all()
  end

  def insert_users() do
    [
      %{name: "Scooby Doo", username: "scoob", password: "parool"},
      %{name: "Norville Rogers", username: "shaggy", password: "parool"}
    ]
    |> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
  end

  def insert_parkinglots() do
    [
      %{
        name: "Lai 7",
        latitude: 58.382177,
        longitude: 26.717216,
        total_spaces: 5,
        parking_zone: "A"
      },
      %{
        name: "Lai 30",
        latitude: 58.383610,
        longitude: 26.719252,
        total_spaces: 20,
        parking_zone: "A"
      },
      %{
        name: "Tiigi 61",
        latitude: 58.374380,
        longitude: 26.711739,
        total_spaces: 10,
        parking_zone: "B"
      },
      %{
        name: "Õpetaja 9",
        latitude: 58.374823,
        longitude: 26.716418,
        total_spaces: 2,
        parking_zone: "B"
      },
      # TODO: causes nil for distance
      #      %{
      #        name: "Juhan Liivi 4",
      #        latitude: 58.378520,
      #        longitude: 26.712730,
      #        total_spaces: 7,
      #        parking_zone: "B"
      #      },
      %{
        # Kalda tee 3, 50703 Tartu
        name: "Kalda tee 3",
        latitude: 58.372120,
        longitude: 26.755070,
        total_spaces: 25,
        parking_zone: "B"
      },
      %{
        # Soola 3a 51013 Tartu
        name: "Soola 3a",
        latitude: 58.377910,
        longitude: 26.732960,
        total_spaces: 12,
        parking_zone: "B"
      },
      %{
        # Turu 10, 51013 Tartu
        name: "Aura Waterpark",
        latitude: 58.376590,
        longitude: 26.736090,
        total_spaces: 20,
        parking_zone: "B"
      },
      %{
        # Uueturu 51004, 51004 Tartu
        name: "Kaubamaja",
        latitude: 58.378740,
        longitude: 26.727570,
        total_spaces: 30,
        parking_zone: "A"
      },
      %{
        # Kroonuaia 56 51007 Tartu
        name: "Supplinn",
        latitude: 58.384370,
        longitude: 26.718040,
        total_spaces: 13,
        parking_zone: "B"
      },
      %{
        # Magistri tänav T1 51005 Tartu
        name: "Magistri tänav T1",
        latitude: 58.381328,
        longitude: 26.724055,
        total_spaces: 25,
        parking_zone: "B"
      },
      %{
        # Ülikooli 4 51003, 51003 Tartu
        name: "Ülikooli 4",
        latitude: 58.378034,
        longitude: 26.723801,
        total_spaces: 25,
        parking_zone: "A"
      },
      %{
        # Vanemuise 24-12, 51003 Tartu
        name: "Vanmuise 24",
        latitude: 58.376081,
        longitude: 26.7218711,
        total_spaces: 25,
        parking_zone: "B"
      }

    ]
    |> Enum.map(fn parkinglot_data -> ParkingLot.changeset(%ParkingLot{}, parkinglot_data) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
  end
end

Findmyparking.DatabaseSeederDev.seed_data()
