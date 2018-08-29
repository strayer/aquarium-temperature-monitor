defmodule AquariumTemperatureMonitor.LCDDriver do
  use GenServer

  alias AquariumTemperatureMonitor.TemperatureMonitor.TemperatureReading

  defmodule Metadata do
    defstruct temperature_reading: nil
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok, nil}
  end

  def update_temperature_reading(%TemperatureReading{} = reading) do
    GenServer.cast(__MODULE__, {:update_temperature_reading, reading})
  end
end
