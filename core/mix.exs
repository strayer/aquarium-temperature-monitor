defmodule AquariumTemperatureMonitor.MixProject do
  use Mix.Project

  def project do
    [
      app: :aquarium_temperature_monitor,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {AquariumTemperatureMonitor.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:httpoison, "~> 1.3"}]
  end
end
