defmodule AquariumTemperatureMonitor.TemperatureReporter do
  @moduledoc """
  A GenServer that periodically reports the current TemperatureReading to an
  InfluxDB instance.
  """
  use GenServer

  require Logger

  alias AquariumTemperatureMonitor.TemperatureMonitor
  alias AquariumTemperatureMonitor.TemperatureMonitor.TemperatureReading
  alias AquariumTemperatureMonitor.TemperatureReporter.InfluxDBHandler

  @default_timer_milliseconds 5 * 60 * 1_000

  @timer_milliseconds Application.get_env(
                        :aquarium_temperature_monitor,
                        :reporter_timer_milliseconds,
                        @default_timer_milliseconds
                      )

  @timer_enabled Application.get_env(
                   :aquarium_temperature_monitor,
                   :reporter_timer_enabled,
                   true
                 )

  ###
  # API
  ###

  def start_link(influxdb_config: influxdb_config) do
    GenServer.start_link(__MODULE__, [influxdb_config: influxdb_config], name: __MODULE__)
  end

  ###
  # Server
  ###

  @impl true
  def init(state) do
    start_timer(0)
    {:ok, state}
  end

  @impl true
  def handle_info(:trigger, state) do
    GenServer.cast(self(), {:handle_reading, TemperatureMonitor.get_reading()})
    {:noreply, state}
  end

  @impl true
  def handle_cast({:handle_reading, new_reading}, state) do
    handle_reading(new_reading, state[:influxdb_config])
    {:noreply, state}
  end

  @impl true
  def format_status(_reason, [_pdict, state]) do
    # Remove InfluxDB config from state to avoid logging secrets
    state =
      Enum.map(state, fn x ->
        case x do
          {:influxdb_config, _} -> {:influxdb_config, "***REDACTED***"}
          _ -> x
        end
      end)

    [data: [{'State', state}]]
  end

  defp start_timer(milliseconds \\ @timer_milliseconds) do
    if @timer_enabled, do: Process.send_after(self(), :trigger, milliseconds)
  end

  defp handle_reading(%TemperatureReading{celsius: nil}, _influxdb_config) do
    # Monitor still initalizing or never read a temperature
    Logger.debug("Reporter received nil celsius TemperatureReading, retrying")

    start_timer(5_000)
  end

  defp handle_reading(%TemperatureReading{datetime: nil}, _influxdb_config) do
    # Monitor still initalizing or never read a temperature
    Logger.debug("Reporter received nil datetime TemperatureReading, retrying")

    start_timer(5_000)
  end

  defp handle_reading(%TemperatureReading{} = reading, influxdb_config) do
    Logger.info("Reporting new temperature (#{reading.celsius}°C)")
    InfluxDBHandler.send_temperature(reading, influxdb_config)
    start_timer()
  end
end
