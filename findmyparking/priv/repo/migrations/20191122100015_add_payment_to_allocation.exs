defmodule Findmyparking.Repo.Migrations.AddPaymentToAllocation do
  use Ecto.Migration

  def change do
    alter table(:allocations) do
      add :payment_type, :string
    end
  end
end
