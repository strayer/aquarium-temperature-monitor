defmodule AquariumTemperatureMonitor.LCDDriver.HardwareImpl do
  @moduledoc """
  A LCD hardware implementation for rendering lines to a HD44780 LCD module
  using `ExLCD`.
  """

  alias ElixirALE.GPIO

  @doc """
  Returns a charlist that represents a ° on HD44780 LCD modules.
  """
  def degree_symbol, do: [223]

  @spec start_link() :: :ok
  def start_link do
    ExLCD.start_link({ExLCD.HD44780, Application.fetch_env!(:aquarium_temperature_monitor, :lcd)})

    {:ok, pid_backlight_button} =
      GPIO.start_link(
        Application.fetch_env!(:aquarium_temperature_monitor, :lcd_pin_backlight_button),
        :input
      )

    {:ok, pid_backlight} =
      GPIO.start_link(
        Application.fetch_env!(:aquarium_temperature_monitor, :lcd_pin_backlight),
        :output
      )

    GPIO.set_int(pid_backlight_button, :both)

    ExLCD.enable(:display)

    {:ok, %{pid_backlight: pid_backlight}}
  end

  @doc """
  Writes to the first line on the LCD module.
  """
  def render_first_line(charlist) do
    ExLCD.home()
    ExLCD.write(charlist)
  end

  def enable_backlight(pid_backlight) do
    GPIO.write(pid_backlight, 1)
  end

  def disable_backlight(pid_backlight) do
    GPIO.write(pid_backlight, 0)
  end
end
