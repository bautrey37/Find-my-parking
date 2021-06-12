defmodule Findmyparking.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :username, :string
      add :hashed_password, :string
      add :search_address, :string
      add :search_start_time, :naive_datetime
      add :search_end_time, :naive_datetime
      add :search_billing_type, :string

      timestamps()
    end
  end
end
