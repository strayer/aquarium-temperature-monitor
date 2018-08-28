# Since configuration is shared in umbrella projects, this file
# should only configure the :aquarium_temperature_monitor application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :aquarium_temperature_monitor,
  monitor_sensor_device_id: "dummy",
  monitor_implementation: AquariumTemperatureMonitor.TemperatureMonitor.TestImpl,
  monitor_timer_milliseconds: 5 * 1_000,
  reporter_timer_milliseconds: 5 * 60 * 1_000,
  influxdb_url: "http://localhost:8086/",
  influxdb_credentials: nil,
  influxdb_db: "aquarium",
  influxdb_measurement: "temperature"

import_config "#{Mix.env()}.exs"
