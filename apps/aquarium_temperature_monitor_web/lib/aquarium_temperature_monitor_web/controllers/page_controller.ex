defmodule AquariumTemperatureMonitorWeb.PageController do
  use AquariumTemperatureMonitorWeb, :controller

  def index(conn, _params) do
    IO.inspect(AquariumTemperatureMonitor.TemperatureMonitor.get_reading())
    render(conn, "index.html")
  end
end
