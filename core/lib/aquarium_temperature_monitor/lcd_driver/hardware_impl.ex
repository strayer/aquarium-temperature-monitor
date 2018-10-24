defmodule AquariumTemperatureMonitor.LCDDriver.HardwareImpl do
  @moduledoc """
  A LCD hardware implementation for rendering lines to a HD44780 LCD module
  using `ExLCD`.
  """
  @doc """
  Returns a charlist that represents a ° on HD44780 LCD modules.
  """
  def degree_symbol, do: [223]

  @spec start_link() :: :ok
  def start_link do
    ExLCD.start_link({ExLCD.HD44780, Application.fetch_env!(:aquarium_temperature_monitor, :lcd)})

    ExLCD.enable(:display)
  end

  @doc """
  Writes to the first line on the LCD module.
  """
  def render_first_line(charlist) do
    ExLCD.home()
    ExLCD.write(charlist)
  end
end
