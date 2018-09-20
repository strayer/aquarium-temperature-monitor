defmodule AquariumTemperatureMonitor.TemperatureMonitorTest do
  use ExUnit.Case, async: true

  alias AquariumTemperatureMonitor.TemperatureMonitor
  alias AquariumTemperatureMonitor.TemperatureMonitor.TemperatureReading

  @valid_reading {:ok,
                  {"33 00 4b 46 ff ff 02 10 f4 : crc=f4 YES",
                   "33 00 4b 46 ff ff 02 10 f4 t=21566"}}
  @valid_no_reading {:ok, {"33 00 4b 46 ff ff 02 10 f4 : crc=f4 NO"}}
  @error_reading {:error, "Something happened"}

  setup do
    {:ok, server} = TemperatureMonitor.start_link("dummy_sensor_id")

    {:ok, server: server}
  end

  test "should start with nil reading", %{server: server} do
    %TemperatureReading{celsius: nil, datetime: nil} = TemperatureMonitor.get_reading()
    :sys.get_state(server)
  end

  test "should not crash with NO reading", %{server: server} do
    GenServer.cast(server, {:parse_reading, @valid_no_reading})
    %TemperatureReading{celsius: nil, datetime: nil} = TemperatureMonitor.get_reading()
    :sys.get_state(server)
  end

  test "should update state with YES reading", %{server: server} do
    GenServer.cast(server, {:parse_reading, @valid_reading})
    %TemperatureReading{celsius: 21.6} = TemperatureMonitor.get_reading()
  end

  test "should not crash with error reading", %{server: server} do
    GenServer.cast(server, {:parse_reading, @error_reading})
    %TemperatureReading{celsius: nil, datetime: nil} = TemperatureMonitor.get_reading()
    :sys.get_state(server)
  end

  test "should update reading on timer trigger", %{server: server} do
    GenServer.cast(server, {:parse_reading, @valid_reading})
    Process.send(server, :trigger_timer, [])

    # Give the async read function some time
    Process.sleep(100)

    assert Map.get(TemperatureMonitor.get_reading(), :celsius) != 21.6
    :sys.get_state(server)
  end
end
