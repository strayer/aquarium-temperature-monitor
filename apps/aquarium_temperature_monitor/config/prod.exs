# Since configuration is shared in umbrella projects, this file
# should only configure the :aquarium_temperature_monitor application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :aquarium_temperature_monitor,
  monitor_implementation: AquariumTemperatureMonitor.TemperatureMonitor.HardwareImpl

import_config "prod.secret.exs"
