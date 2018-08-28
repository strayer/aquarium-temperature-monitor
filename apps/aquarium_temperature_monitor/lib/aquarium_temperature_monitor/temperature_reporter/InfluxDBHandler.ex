defmodule AquariumTemperatureMonitor.TemperatureReporter.InfluxDBHandler do
  alias AquariumTemperatureMonitor.TemperatureMonitor.TemperatureReading

  @url String.trim_trailing(
         Application.fetch_env!(
           :aquarium_temperature_monitor,
           :influxdb_url
         ),
         "/"
       )

  @db Application.fetch_env!(
        :aquarium_temperature_monitor,
        :influxdb_db
      )

  @measurement Application.fetch_env!(
                 :aquarium_temperature_monitor,
                 :influxdb_measurement
               )

  def send_temperature(%TemperatureReading{} = reading) do
    {:ok, %HTTPoison.Response{status_code: 204}} =
      reading
      |> build_data()
      |> send_data()
  end

  defp build_data(reading) do
    "#{@measurement} value=#{Float.to_string(reading.celsius)} #{
      format_datetime(reading.datetime)
    }"
  end

  defp send_data(data) do
    HTTPoison.post("#{@url}/write?db=#{URI.encode(@db)}", data)
  end

  defp format_datetime(datetime) do
    DateTime.to_unix(datetime, :nanoseconds)
  end
end
