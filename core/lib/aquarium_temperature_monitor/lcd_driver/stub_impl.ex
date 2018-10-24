defmodule AquariumTemperatureMonitor.LCDDriver.StubImpl do
  require Logger

  def degree_symbol, do: '°'

  def start_link do
  end

  def render_first_line(charlist) do
    Logger.debug(fn -> "LCD would render '#{charlist}' as first line" end)
  end
end
