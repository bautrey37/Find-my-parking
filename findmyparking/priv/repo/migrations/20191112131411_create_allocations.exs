defmodule Findmyparking.Repo.Migrations.CreateAllocations do
  use Ecto.Migration

  def change do
    create table(:allocations) do
      add :user_id, references(:users)
      add :parking_lot_id, references(:parking_lots)
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime

      timestamps()
    end

    #    create unique_index(:allocations, [:user_id, :parking_lot_id])
  end
end
