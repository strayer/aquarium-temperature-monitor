defmodule AquariumTemperatureMonitorWeb.PageController do
  use AquariumTemperatureMonitorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
