defmodule AquariumTemperatureMonitor.TemperatureReporter.InfluxDBHandler do
  alias AquariumTemperatureMonitor.TemperatureMonitor.TemperatureReading

  @headers [
    "User-Agent":
      "#{Atom.to_string(:aquarium_temperature_monitor)}/#{Mix.Project.config()[:version]}"
  ]

  def send_temperature(%TemperatureReading{} = reading, config) do
    {:ok, %HTTPoison.Response{status_code: 204}} =
      reading
      |> build_data(config)
      |> send_data(config)
  end

  defp build_data(reading, config) do
    "#{config[:measurement]} value=#{Float.to_string(reading.celsius)} #{
      format_datetime(reading.datetime)
    }"
  end

  defp send_data(data, config) do
    url = String.trim_trailing(config[:url], "/")
    HTTPoison.post("#{url}/write?db=#{URI.encode(config[:db])}", data, @headers)
  end

  defp format_datetime(datetime) do
    DateTime.to_unix(datetime, :nanoseconds)
  end
end
