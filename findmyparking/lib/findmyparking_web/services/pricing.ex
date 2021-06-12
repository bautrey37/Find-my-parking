defmodule FindmyparkingWeb.Pricing do
  @doc """
  Calculates the price to pay

  Hourly based payment:
  Zone A - 2 euros per hour, 15 minutes free
  Zone B - 1 euros per hour, 90 minutes free

  Real time payment:
  Zone A - 16 cents per 5 minutes, 15 minutes free
  Zone B - 8 cents per 5 minutes, 90 minutes free
  """
  def calculate_price(zone, start_time, end_time, payment_type) do
    with(
      {:ok} <- validate_times(start_time, end_time),
      {:ok} <- validate_zone(zone),
      {:ok} <- validate_payment_type(payment_type)
    ) do
      elapsed_minutes = div(NaiveDateTime.diff(end_time, start_time), 60)

      case {zone, elapsed_minutes, payment_type} do
        {"A", elapsed_minutes, _} when elapsed_minutes <= 15 -> {:ok, 0}
        {"B", elapsed_minutes, _} when elapsed_minutes <= 90 -> {:ok, 0}
        {"A", _, "hourly"} -> {:ok, calc(elapsed_minutes - 15, 2, 60)}
        {"B", _, "hourly"} -> {:ok, calc(elapsed_minutes - 90, 1, 60)}
        {"A", _, "real"} -> {:ok, calc(elapsed_minutes - 15, 0.16, 5)}
        {"B", _, "real"} -> {:ok, calc(elapsed_minutes - 90, 0.08, 5)}
      end
    else
      {:error, error} ->
        IO.puts(error)
        {:error, error}
    end
  end

  defp validate_times(start_time, end_time) do
    case NaiveDateTime.compare(end_time, start_time) do
      :gt -> {:ok}
      :lt -> {:error, "The start time is greater than the end time"}
      :eq -> {:error, "The start time is equal to the end time"}
    end
  end

  defp validate_zone(zone) when zone == "A" or zone == "B", do: {:ok}
  defp validate_zone(zone), do: {:error, "The zone is wrong: " <> zone}

  defp validate_payment_type(payment_type)
       when payment_type == "hourly" or payment_type == "real",
       do: {:ok}

  defp validate_payment_type(payment_type),
    do: {:error, "The payment type is wrong: " <> payment_type}

  defp calc(minutes_to_pay, price_per_minutes, minutes_per_price_increment) do
    cond do
      rem(minutes_to_pay, minutes_per_price_increment) > 0 ->
        (div(minutes_to_pay, minutes_per_price_increment) + 1) * price_per_minutes

      true ->
        div(minutes_to_pay, minutes_per_price_increment) * price_per_minutes
    end
  end
end
