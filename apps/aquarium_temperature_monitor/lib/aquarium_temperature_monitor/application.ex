defmodule AquariumTemperatureMonitor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    temp_sensor_device_id = System.get_env("TEMP_SENSOR_DEVICE_ID")

    children = [
      {AquariumTemperatureMonitor.TemperatureMonitor, temp_sensor_device_id},
      AquariumTemperatureMonitor.LCDDriver,
      AquariumTemperatureMonitor.TemperatureReporter
    ]

    opts = [strategy: :one_for_one, name: AquariumTemperatureMonitor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
