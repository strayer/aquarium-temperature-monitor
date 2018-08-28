# Since configuration is shared in umbrella projects, this file
# should only configure the :aquarium_temperature_monitor application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :aquarium_temperature_monitor,
  reporter_timer_milliseconds: 5 * 1_000
