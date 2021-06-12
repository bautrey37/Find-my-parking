defmodule FindmyparkingWeb.Geolocation do
  @doc """
  Determines the distance from the origin to the destination latitude and longitude.
  """
  def distance(originLatitude, originLongitude, destinationLatitude, destinationLongitude) do
    [o1, o2] = [originLatitude, originLongitude]
    [d1, d2] = [destinationLatitude, destinationLongitude]

    uri =
      "https://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix?origins=#{o1},#{o2}&destinations=#{
        d1
      },#{d2}&travelMode=driving&key=#{get_key()}"

    response = HTTPoison.get!(uri)
    matches = Regex.named_captures(~r/travelDistance\D+(?<dist>\d+\.\d+)/, response.body)

    IO.inspect(matches)
    [{v1, _}] = [matches["dist"] |> Float.parse()]
    # TODO: fix when matches is nil sometimes
    #    [{v1, _}] = [
    #      case matches do
    #        nil -> 0 # sometimes returns nil when addresses are too close together
    #        _ -> Float.parse([matches["dist"]])
    #      end
    #    ]
    v1
  end

  @doc """
  Given an address, determines the latitude and longitude
  """
  def find_location(address) do
    uri =
      "http://dev.virtualearth.net/REST/v1/Locations?q=1#{URI.encode(address)}%&key=#{get_key()}"

    response = HTTPoison.get!(uri)

    matches =
      Regex.named_captures(
        ~r/coordinates\D+(?<lat>-?\d+.\d+)\D+(?<long>-?\d+.\d+)/,
        response.body
      )

    [{v1, _}, {v2, _}] = [matches["lat"] |> Float.parse(), matches["long"] |> Float.parse()]
    IO.inspect([v1, v2])
    [v1, v2]
  end

  defp get_key(), do: "ApB-6HM882leypxwisTb4DZqvP05ASq2R1jEIaplEzdGqojzFlz5DUR6Ssy8kXUN"
end
