use Mix.Config

config :aquarium_temperature_monitor,
  monitor_implementation: AquariumTemperatureMonitor.TemperatureMonitor.TestImpl,
  monitor_sensor_device_id: "dummy",
  monitor_timer_milliseconds: nil,
  reporter_timer_enabled: false,
  influxdb_url: "dummy",
  influxdb_credentials: nil,
  influxdb_db: "aquarium",
  influxdb_measurement: "temperature",
  lcd_implementation: AquariumTemperatureMonitor.LCDDriver.StubImpl
