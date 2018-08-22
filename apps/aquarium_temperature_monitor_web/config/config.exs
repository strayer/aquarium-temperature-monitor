# Since configuration is shared in umbrella projects, this file
# should only configure the :aquarium_temperature_monitor_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :aquarium_temperature_monitor_web,
  generators: [context_app: :aquarium_temperature_monitor]

# Configures the endpoint
config :aquarium_temperature_monitor_web, AquariumTemperatureMonitorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lz8+rGyamChW22JMoIAn5jyILgzp4oymSpwjNPAyGln3pOjcvZr5k03gSCTJgKCe",
  render_errors: [view: AquariumTemperatureMonitorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AquariumTemperatureMonitorWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
