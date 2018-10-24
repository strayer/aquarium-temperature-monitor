defmodule AquariumTemperatureMonitor.TemperatureMonitor.HardwareImpl do
  @moduledoc """
  The hardware implementation for reading temperatures from Dallas 1-Wire
  temperature sensors like the DS18B20.
  """

  @behaviour AquariumTemperatureMonitor.TemperatureMonitor.Behaviour

  @sys_dir "/sys/bus/w1/devices/"

  @impl true
  def read_temperature(device_id) do
    path = Path.join([@sys_dir, "28-" <> device_id, "w1_slave"])

    if File.exists?(path) do
      {:ok, contents} = File.read(path)

      {:ok,
       contents
       |> String.trim()
       |> String.split("\n")
       |> List.to_tuple()}
    else
      {:error, "Device not found!"}
    end
  end
end
