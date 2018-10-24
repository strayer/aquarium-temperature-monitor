defmodule AquariumTemperatureMonitor.TemperatureReporter.InfluxDBHandler do
  @moduledoc """
  Contains functions to report temperature readings to an InfluxDB instance.
  """

  alias AquariumTemperatureMonitor.TemperatureMonitor.TemperatureReading

  @headers [
    "User-Agent":
      "#{Atom.to_string(:aquarium_temperature_monitor)}/#{Mix.Project.config()[:version]}"
  ]

  @doc """
  Sends a `AquariumTemperatureMonitor.TemperatureMonitor.TemperatureReading` to
  a configured InfluxDB instance.
  """
  def send_temperature(%TemperatureReading{} = reading, config) do
    {:ok, %HTTPoison.Response{status_code: 204}} =
      reading
      |> build_data(config)
      |> send_data(config)
  end

  defp build_data(%{celsius: celsius, datetime: datetime}, %{measurement: measurement}) do
    "#{measurement} value=#{Float.to_string(celsius)} #{format_datetime(datetime)}"
  end

  defp send_data(data, %{url: url, db: db} = config) do
    url = String.trim_trailing(url, "/")

    HTTPoison.post(
      "#{url}/write?db=#{URI.encode(db)}",
      data,
      @headers,
      create_httpoison_options(config)
    )
  end

  defp format_datetime(datetime) do
    DateTime.to_unix(datetime, :nanoseconds)
  end

  defp create_httpoison_options(%{credentials: credentials}) do
    if credentials do
      [
        hackney: [
          basic_auth:
            credentials
            |> String.split(":")
            |> List.to_tuple()
        ]
      ]
    else
      []
    end
  end
end
