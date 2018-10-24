defmodule AquariumTemperatureMonitor.LCDDriver.HardwareImpl do
  def degree_symbol, do: [223]

  def start_link() do
    ExLCD.start_link({ExLCD.HD44780, Application.fetch_env!(:aquarium_temperature_monitor, :lcd)})

    ExLCD.enable(:display)
  end

  def render_first_line(charlist) do
    ExLCD.home()
    ExLCD.write(charlist)
  end
end
