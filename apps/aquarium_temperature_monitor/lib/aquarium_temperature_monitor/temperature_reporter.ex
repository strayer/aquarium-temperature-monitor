defmodule AquariumTemperatureMonitor.TemperatureReporter do
  use GenServer

  require Logger

  alias AquariumTemperatureMonitor.TemperatureMonitor
  alias AquariumTemperatureMonitor.TemperatureMonitor.TemperatureReading
  alias AquariumTemperatureMonitor.TemperatureReporter.InfluxDBHandler

  @timer_milliseconds Application.fetch_env!(
                        :aquarium_temperature_monitor,
                        :reporter_timer_milliseconds
                      )

  ###
  # API
  ###

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  ###
  # Server
  ###

  @impl true
  def init(_) do
    start_timer(0)
    {:ok, nil}
  end

  @impl true
  def handle_info(:trigger, state) do
    handle_reading(TemperatureMonitor.get_reading())
    {:noreply, state}
  end

  defp start_timer(milliseconds) do
    Process.send_after(self(), :trigger, milliseconds)
  end

  defp handle_reading(%TemperatureReading{celsius: nil}) do
    # Monitor still initalizing or never read a temperature
    Logger.debug("Reporter received nil celsius TemperatureReading, retrying")

    start_timer(5_000)
  end

  defp handle_reading(%TemperatureReading{datetime: nil}) do
    # Monitor still initalizing or never read a temperature
    Logger.debug("Reporter received nil datetime TemperatureReading, retrying")

    start_timer(5_000)
  end

  defp handle_reading(%TemperatureReading{} = reading) do
    Logger.info("Reporting new temperature (#{reading.celsius}°C)")
    InfluxDBHandler.send_temperature(reading)
    start_timer(@timer_milliseconds)
  end
end
