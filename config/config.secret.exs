use Mix.Config

twitch_client_id =
  System.get_env("TWITCH_CLIENT_ID") ||
    raise "environment variable TWITCH_CLIENT_ID is missing."

twitch_client_secret =
  System.get_env("TWITCH_CLIENT_SECRET") ||
    raise "environment variable TWITCH_CLIENT_SECRET is missing."

config :frick_dmca, :pow_assent,
  providers: [
    twitch: [
      client_id: twitch_client_id,
      client_secret: twitch_client_secret,
      strategy: FrickDmca.Auth.Twitch
    ]
  ]
