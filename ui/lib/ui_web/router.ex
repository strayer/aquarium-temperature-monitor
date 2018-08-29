defmodule UiWeb.Router do
  use UiWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(PlugPreferredLocales, ignore_area: true)
    plug(:set_language)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", UiWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", UiWeb do
  #   pipe_through :api
  # end

  def set_language(conn, _opts) do
    preferred_languages = MapSet.new(conn.private.plug_preferred_locales)

    available_languages =
      UiWeb.Gettext
      |> Gettext.known_locales()
      |> MapSet.new()

    intersection = MapSet.intersection(preferred_languages, available_languages)

    if MapSet.size(intersection) > 0 do
      intersection
      |> MapSet.to_list()
      |> List.first()
      |> Gettext.put_locale()
    end

    conn
  end
end
