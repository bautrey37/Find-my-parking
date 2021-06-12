defmodule FindmyparkingWeb.PricingTest do
  use FindmyparkingWeb.ConnCase
  import FindmyparkingWeb.Pricing

  @doc """
  The free time for zone A is 15 minutes.
  """
  test "calculate price; is free; zone: A" do
    # 14 minute difference
    startTime = ~N[2019-12-03 16:00:00.000]
    endTime = ~N[2019-12-03 16:14:00.000]
    zone = "A"
    paymentType = "hourly"

    result = calculate_price(zone, startTime, endTime, paymentType)
    assert result == {:ok, 0}
  end

  @doc """
  The free time for zone B is under 90 minutes
  """
  test "calculate price; is free; zone: B" do
    # 80 minute difference
    startTime = ~N[2019-12-03 16:00:00.000]
    endTime = ~N[2019-12-03 17:20:00.000]
    zone = "B"
    paymentType = "hourly"

    result = calculate_price(zone, startTime, endTime, paymentType)
    assert result == {:ok, 0}
  end

  @doc """
  Zone A parking for 2 hour using hourly payment
  """
  test "1.4, 1.2: calculate price; zone: A, paymentType: hourly" do
    # 2 hours difference
    startTime = ~N[2019-12-03 16:00:00.000]
    endTime = ~N[2019-12-03 18:00:00.000]
    zone = "A"
    paymentType = "hourly"

    result = calculate_price(zone, startTime, endTime, paymentType)
    assert result == {:ok, 4}
  end

  @doc """
  Zone B parking for 2 hour using hourly payment
  """
  test "1.4, 1.2: calculate price; zone: B, paymentType: hourly" do
    # 2 hours difference
    startTime = ~N[2019-12-03 16:00:00.000]
    endTime = ~N[2019-12-03 18:00:00.000]
    zone = "B"
    paymentType = "hourly"

    result = calculate_price(zone, startTime, endTime, paymentType)
    assert result == {:ok, 1}
  end

  @doc """
  Zone A parking for 2 hours and 30 minutes using real time payment
  """
  test "1.5, 1.2: calculate price; zone: A, paymentType: real" do
    # 2 hour and 30 minute difference
    startTime = ~N[2019-12-03 16:00:00.000]
    endTime = ~N[2019-12-03 18:30:00.000]
    zone = "A"
    paymentType = "real"

    result = calculate_price(zone, startTime, endTime, paymentType)
    assert result == {:ok, 4.32}
  end

  @doc """
  Zone B parking for 4 hours and 30 minutes using real time payment
  """
  test "1.5, 1.2: calculate price; zone: B, paymentType: real" do
    # 4 hours and 30 minute difference
    startTime = ~N[2019-12-03 12:00:00.000]
    endTime = ~N[2019-12-03 16:30:00.000]
    zone = "B"
    paymentType = "real"

    result = calculate_price(zone, startTime, endTime, paymentType)
    assert result == {:ok, 2.88}
  end

  test "calculate price; invalid zone" do
    startTime = ~N[2019-12-03 12:00:00.000]
    endTime = ~N[2019-12-03 16:30:00.000]
    zone = "free"
    paymentType = "real"
    result = calculate_price(zone, startTime, endTime, paymentType)
    assert result == {:error, "The zone is wrong: free"}
  end

  test "calculate price; start time greater than end time" do
    startTime = ~N[2019-12-03 14:00:00.000]
    endTime = ~N[2019-12-03 12:30:00.000]
    zone = "A"
    paymentType = "real"
    result = calculate_price(zone, startTime, endTime, paymentType)
    assert result == {:error, "The start time is greater than the end time"}
  end

  test "calculate price; start time equal to end time" do
    startTime = ~N[2019-12-03 12:30:00.000]
    endTime = ~N[2019-12-03 12:30:00.000]
    zone = "A"
    paymentType = "real"
    result = calculate_price(zone, startTime, endTime, paymentType)
    assert result == {:error, "The start time is equal to the end time"}
  end

  test "calculate price; payment type is wrong" do
    startTime = ~N[2019-12-03 12:30:00.000]
    endTime = ~N[2019-12-03 12:40:00.000]
    zone = "A"
    paymentType = "blah"
    result = calculate_price(zone, startTime, endTime, paymentType)
    assert result == {:error, "The payment type is wrong: blah"}
  end
end
