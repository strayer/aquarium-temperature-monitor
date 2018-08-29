defmodule AquariumTemperatureMonitor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    sensor_device_id = get_config(:monitor_sensor_device_id)

    influxdb_config = %{
      url: get_config(:influxdb_url),
      credentials: get_config(:influxdb_credentials),
      db: get_config(:influxdb_db),
      measurement: get_config(:influxdb_measurement)
    }

    children = [
      {AquariumTemperatureMonitor.TemperatureMonitor, sensor_device_id},
      AquariumTemperatureMonitor.LCDDriver,
      {AquariumTemperatureMonitor.TemperatureReporter, influxdb_config: influxdb_config}
    ]

    opts = [strategy: :one_for_one, name: AquariumTemperatureMonitor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_config(app_env_atom) do
    Application.fetch_env!(
      :aquarium_temperature_monitor,
      app_env_atom
    )
  end
end
