defmodule UiWeb.PageController do
  require Timex.Translator

  use UiWeb, :controller

  def index(conn, _params) do
    current_reading = AquariumTemperatureMonitor.TemperatureMonitor.get_reading()

    time_ago = Timex.from_now(current_reading.datetime, Gettext.get_locale())

    conn
    |> assign(:celsius, current_reading.celsius)
    |> assign(:measured_time_ago, time_ago)
    |> render("index.html")
  end
end
