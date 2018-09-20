# Since configuration is shared in umbrella projects, this file
# should only configure the :aquarium_temperature_monitor application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :aquarium_temperature_monitor,
  monitor_implementation: AquariumTemperatureMonitor.TemperatureMonitor.TestImpl,
  monitor_sensor_device_id: "dummy",
  monitor_timer_enabled: false,
  reporter_timer_enabled: false,
  influxdb_url: "dummy",
  influxdb_credentials: nil,
  influxdb_db: "aquarium",
  influxdb_measurement: "temperature"
