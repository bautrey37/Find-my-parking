defmodule Findmyparking.Repo.Migrations.AddPaymentStatusToAllocation do
  use Ecto.Migration

  def change do
    alter table(:allocations) do
      add :payment_status, :string
    end
  end
end
