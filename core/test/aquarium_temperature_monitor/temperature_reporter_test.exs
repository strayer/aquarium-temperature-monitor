defmodule AquariumTemperatureMonitor.TemperatureReporterTest do
  use ExUnit.Case, async: true

  alias AquariumTemperatureMonitor.TemperatureReporter
  alias AquariumTemperatureMonitor.TemperatureMonitor.TemperatureReading

  @nil_celsius_reading %TemperatureReading{celsius: nil, datetime: DateTime.utc_now()}
  @nil_datetime_reading %TemperatureReading{celsius: 27.0, datetime: nil}
  @valid_reading %TemperatureReading{celsius: 27.0, datetime: DateTime.utc_now()}

  setup do
    bypass = Bypass.open()

    {:ok, server} =
      TemperatureReporter.start_link(
        influxdb_config: %{
          url: "http://localhost:" <> Integer.to_string(bypass.port),
          db: "testdb",
          measurement: "testmeasurement",
          credentials: "testuser:testpass"
        }
      )

    {:ok, bypass: bypass, server: server}
  end

  test "should not call InfluxDB with nil celsius", %{server: server} do
    GenServer.cast(server, {:handle_reading, @nil_celsius_reading})
    :sys.get_state(server)
  end

  test "should not call InfluxDB with nil datetime", %{server: server} do
    GenServer.cast(server, {:handle_reading, @nil_datetime_reading})
    :sys.get_state(server)
  end

  test "should call InfluxDB with valid reading", %{bypass: bypass, server: server} do
    Bypass.expect_once(bypass, fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)

      assert "/write" == conn.request_path
      assert %{"db" => "testdb"} == conn.params
      assert "POST" == conn.method
      assert ["Basic dGVzdHVzZXI6dGVzdHBhc3M="] == Plug.Conn.get_req_header(conn, "authorization")

      assert ["aquarium_temperature_monitor/" <> Mix.Project.config()[:version]] ==
               Plug.Conn.get_req_header(conn, "user-agent")

      # TODO assert request content

      Plug.Conn.resp(conn, 204, "")
    end)

    GenServer.cast(server, {:handle_reading, @valid_reading})
    :sys.get_state(server)
  end
end
