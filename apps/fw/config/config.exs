# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.
config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

config :nerves_init_gadget,
  mdns_domain: "aquariumpi.local",
  node_name: "aquariumpi"

# config :nerves_network,
#   regulatory_domain: "DE"

# key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

# config :nerves_network, :default,
#   wlan0: [
#     ssid: System.get_env("NERVES_NETWORK_SSID"),
#     psk: System.get_env("NERVES_NETWORK_PSK"),
#     key_mgmt: String.to_atom(key_mgmt)
#   ]

config :nerves_firmware_ssh,
  authorized_keys: [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCgui4ILeD+1ydZXKVoIJLmDNYSEB0vwFWLhk0IC3zqv6xcoxA7CM5LKGD/RBZGuITv6x+aNoZP5RdZjsD7Y5LPD10h4S+G6UDoNF0cVS45yV5kpepzv6eplaqnsYZcvMUvktimrlx1GKPNWUVcz5FRD9naXe2KWnJ7hKqvPutMrg3adLxPU89WZeVXG+1XP8UxseZBLRpkhC2VI4S4yJPY4a5gVWd2uRjVo11roswZV3EgLPLCE52HUGMRHlC7bv0QynTrWlPi45FrpGBpqfaBQDMQOHd32pBj9gs+KclJ7uO3yG5vEkrhEbm3IA8+nfdL1FnCzR5v5I74fHq5ROxu/59oPnoatHwZHrChOD2BfcD6UydQo/uYWGNXcODM8OAGv9nqxAMJkGI526b9sBwdMpxCeSyX4/dAS6tsvQ9ZgmuPIV8TAtZlfUWmlBaVOTOAnQ/M49b2LRfT7QoXcA8jgJh034ZmoByfF+0j+mEoirWn/JWDNuzcA7FkfjC2La25hhELWGgoUx2IuFKv5/BL5aUVJ2jXWxKrjb6fLhdvKT42WZ4kS/KfZ2rCqQA/RiAfKEk0RnHPU5BQZt+ojvCEDCA6Xiqd7zHiNHELLcbnDIu7+C4RMwsi7NLu8IVNkdzuy3Z1MxjgBqgs0nBWg33ZAVavhGHHbNPt1DOnt+wVKw=="
  ]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
