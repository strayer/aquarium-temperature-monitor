defmodule AquariumTemperatureMonitor.LCDDriver.StubImpl do
  @moduledoc """
  A stub LCD implementation, intended for debugging and testing.
  """

  require Logger

  def degree_symbol, do: '°'

  def start_link do
    {:ok, %{pid_backlight: nil}}
  end

  def render_first_line(charlist) do
    Logger.debug(fn -> "LCD would render '#{charlist}' as first line" end)
  end

  def enable_backlight() do
  end

  def disable_backlight() do
  end
end
