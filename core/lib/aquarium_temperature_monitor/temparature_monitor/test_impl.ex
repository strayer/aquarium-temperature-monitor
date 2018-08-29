defmodule AquariumTemperatureMonitor.TemperatureMonitor.TestImpl do
  @behaviour AquariumTemperatureMonitor.TemperatureMonitor.Behaviour

  alias AquariumTemperatureMonitor.TemperatureMonitor.TemperatureReading

  @impl true
  def read_temperature(device_id) do
    {:ok,
     {"33 00 4b 46 ff ff 02 10 f4 : crc=f4 YES",
      "33 00 4b 46 ff ff 02 10 f4 t=" <> get_random_temperature()}}
  end

  defp get_random_temperature() do
    "27" <> String.pad_leading(Integer.to_string(Enum.random(0..999)), 3, "0")
  end
end
