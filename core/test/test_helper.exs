# Since mix tests runs with --no-start, start required applications manually
Application.ensure_all_started(:hackney)

ExUnit.start()
Application.ensure_all_started(:bypass)
