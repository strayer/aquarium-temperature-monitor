defmodule AquariumTemperatureMonitor.TemperatureMonitor.TestImpl do
  @behaviour AquariumTemperatureMonitor.TemperatureMonitor.Behaviour

  @impl true
  def read_temperature(_device_id) do
    # Simulate the time it takes to read the sensor
    unless Mix.env() == :test, do: Process.sleep(Enum.random(0..999) + 1_000)

    {:ok,
     {"33 00 4b 46 ff ff 02 10 f4 : crc=f4 YES",
      "33 00 4b 46 ff ff 02 10 f4 t=" <> get_random_temperature()}}
  end

  defp get_random_temperature do
    "27" <> String.pad_leading(Integer.to_string(Enum.random(0..999)), 3, "0")
  end
end
