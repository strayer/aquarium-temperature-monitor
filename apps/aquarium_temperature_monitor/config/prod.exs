# Since configuration is shared in umbrella projects, this file
# should only configure the :aquarium_temperature_monitor application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Set most settings from environment at compile time since prod is deployed with
# nerves anyway
config :aquarium_temperature_monitor,
  monitor_implementation: AquariumTemperatureMonitor.TemperatureMonitor.HardwareImpl
  monitor_sensor_device_id: System.get_env("SENSOR_DEVICE_ID"),
  monitor_timer_milliseconds: 5 * 1_000,
  reporter_timer_milliseconds: 5 * 60 * 1_000,
  influxdb_url: System.get_env("INFLUXDB_URL"),
  influxdb_credentials: System.get_env("INFLUXDB_CREDENTIALS"),
  influxdb_db: System.get_env("INFLUXDB_DB"),
  influxdb_measurement: System.get_env("INFLUXDB_MEASUREMENT")
