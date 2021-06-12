defmodule Findmyparking.Allocation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "allocations" do
    belongs_to :user, Findmyparking.User
    belongs_to :parking_lot, Findmyparking.ParkingLot
    field :start_time, :naive_datetime
    field :end_time, :naive_datetime
    field :payment_type, :string
    field :payment_status, :string
    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :start_time,
      :end_time,
      :payment_type,
      :user_id,
      :parking_lot_id,
      :payment_status
    ])
    |> validate_required([:start_time, :end_time, :payment_type, :user_id, :parking_lot_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:parking_lot)
  end
end
