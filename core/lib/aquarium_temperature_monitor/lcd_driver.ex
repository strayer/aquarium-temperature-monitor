defmodule AquariumTemperatureMonitor.LCDDriver do
  @moduledoc """
  A GenServer controlling a LCD module displaying, among other things, the
  current TemperatureReading.
  """
  require Logger

  use GenServer

  alias AquariumTemperatureMonitor.TemperatureMonitor.TemperatureReading

  @implementation Application.fetch_env!(:aquarium_temperature_monitor, :lcd_implementation)

  ###
  # API
  ###

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def update_temperature_reading(%TemperatureReading{} = reading) do
    GenServer.cast(__MODULE__, {:update_temperature_reading, reading})
  end

  ###
  # Server
  ###

  @impl true
  def init(_) do
    @implementation.start_link()
    {:ok, start_timer(%{temperature_reading: nil, timer_ref: nil})}
  end

  @impl true
  def handle_cast({:update_temperature_reading, reading}, state) do
    {:noreply,
     state
     |> Map.put(:temperature_reading, reading)
     |> start_timer(0)}
  end

  @impl true
  def handle_info(:update_lcd, %{temperature_reading: nil} = state) do
    {:noreply, state}
  end

  @impl true
  def handle_info(:update_lcd, state) do
    Logger.debug(fn -> "Updating LCD with temperature #{state.temperature_reading.celsius}" end)

    state
    |> format_first_line()
    |> @implementation.render_first_line()

    {:noreply, start_timer(state)}
  end

  def format_temperature(%{temperature_reading: nil}) do
    ''
  end

  def format_temperature(%{temperature_reading: %{celsius: celsius}}) do
    "~.1f"
    |> :io_lib.format([celsius])
    |> Enum.map(fn x -> if x == ".", do: ",", else: x end)
    |> Enum.concat(@implementation.degree_symbol())
    |> Enum.concat('C')
  end

  def format_time_since(%{temperature_reading: nil}) do
    ''
  end

  def format_time_since(%{temperature_reading: %{datetime: datetime}}) do
    DateTime.utc_now()
    |> DateTime.diff(datetime)
    |> Timex.Duration.from_seconds()
    |> Timex.format_duration()
    |> String.replace("P", "")
    |> String.replace("T", "")
    |> String.downcase()
    |> (fn x -> if x == "", do: "0s", else: x end).()
    |> String.to_charlist()
  end

  def format_first_line(state) do
    temp_part =
      state
      |> format_temperature()
      |> enum_pad(8, :trailing)

    time_since_part =
      state
      |> format_time_since()
      |> enum_pad(8)

    temp_part ++ time_since_part
  end

  defp start_timer(state, time \\ 1_000) do
    if state.timer_ref, do: Process.cancel_timer(state.timer_ref)
    %{state | timer_ref: Process.send_after(self(), :update_lcd, time)}
  end

  defp enum_pad(enum, desired_length, direction \\ :leading) do
    padding = Enum.map(1..(desired_length - length(enum)), fn _ -> 32 end)

    if direction == :leading do
      padding ++ enum
    else
      enum ++ padding
    end
  end
end
