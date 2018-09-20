defmodule AquariumTemperatureMonitor.TemperatureMonitor do
  @moduledoc """
  A GenServer that periodically reads the temperature of a configured
  implementation with a configured interval. Allows retrival of the current
  reading and sends it to relevant GenServers.
  """

  use GenServer
  require Logger

  defmodule TemperatureReading do
    @typedoc """
    A struct that represents a temperature reading with a celsius and DateTime.
    """
    @type t :: %__MODULE__{
            celsius: Float.t() | nil,
            datetime: nil
          }

    defstruct celsius: nil, datetime: nil
  end

  defmodule State do
    defstruct device_id: nil, current_reading: %TemperatureReading{}
  end

  defmodule Behaviour do
    @callback read_temperature(String.t()) ::
                {:ok, {String.t(), String.t()}} | {:error, String.t()}
  end

  @implementation Application.fetch_env!(:aquarium_temperature_monitor, :monitor_implementation)

  @default_timer_milliseconds 5 * 1_000

  @timer_milliseconds Application.get_env(
                        :aquarium_temperature_monitor,
                        :monitor_timer_milliseconds,
                        @default_timer_milliseconds
                      )

  @timer_enabled Application.get_env(
                   :aquarium_temperature_monitor,
                   :monitor_timer_enabled,
                   true
                 )

  ###
  # API
  ###

  def start_link(device_id) do
    GenServer.start_link(__MODULE__, %State{device_id: device_id}, name: __MODULE__)
  end

  def get_reading() do
    GenServer.call(__MODULE__, :get_reading)
  end

  ###
  # Server
  ###

  @impl true
  def init(%State{} = initial_state) do
    start_timer(self(), 0)
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:get_reading, _from, state) do
    {:reply, state.current_reading, state}
  end

  @impl true
  def handle_info(:trigger_timer, state) do
    pid = self()

    # Read temperature asynchronously to avoid blocking
    spawn(fn ->
      new_reading = @implementation.read_temperature(state.device_id)

      GenServer.cast(pid, {:parse_reading, new_reading})

      # Restart the timer
      start_timer(pid)
    end)

    {:noreply, state}
  end

  @impl true
  def handle_cast({:parse_reading, raw_reading}, state) do
    old_reading = state.current_reading

    new_state =
      raw_reading
      |> parse_raw_reading()
      |> update_state_with_reading(state)

    # TODO send temperature to LCDDriver

    log_temperature_change(old_reading.celsius, new_state.current_reading.celsius)

    {:noreply, new_state}
  end

  defp parse_raw_reading({:ok, {line1}}), do: parse_raw_reading({:ok, {line1, ""}})

  defp parse_raw_reading({:ok, {line1, line2}}) do
    if String.ends_with?(line1, "YES") do
      {:ok, parse_temp_line(line2)}
    else
      {:error, "Got NO from sensor when reading temparature"}
    end
  end

  defp parse_raw_reading(input) do
    # Ignore false readings and errors
    input
  end

  defp parse_temp_line(temp_line) do
    celsius =
      temp_line
      |> String.split("t=")
      |> Enum.fetch!(1)
      |> String.to_integer()
      |> Kernel./(1000)
      |> Float.round(1)

    %TemperatureReading{
      celsius: celsius,
      datetime: DateTime.utc_now()
    }
  end

  defp update_state_with_reading({:ok, %TemperatureReading{} = new_reading}, %State{} = state) do
    Map.put(state, :current_reading, new_reading)
  end

  defp update_state_with_reading({:error, message}, %State{} = state) do
    Logger.error("Received error when reading temperature: #{message}")
    state
  end

  defp log_temperature_change(nil, new_celsius) do
    Logger.debug("Initial temperature reading: #{new_celsius}")
  end

  defp log_temperature_change(old_celsius, new_celsius) when old_celsius != new_celsius do
    Logger.debug("Temperature changed: #{old_celsius} -> #{new_celsius}")
  end

  defp log_temperature_change(_, _) do
  end

  defp start_timer(pid, time \\ @timer_milliseconds) do
    if @timer_enabled, do: Process.send_after(pid, :trigger_timer, time)
  end
end
