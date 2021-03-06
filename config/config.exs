# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :frick_dmca,
  ecto_repos: [FrickDmca.Repo]

# Configures the endpoint
config :frick_dmca, FrickDmcaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "r1Bo8aSYHxZug4ny/arb8Z/qUqp+Gq7Y07E4GszXB50brjbD00Ol4BrvdFlHGVwW",
  render_errors: [view: FrickDmcaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FrickDmca.PubSub,
  live_view: [signing_salt: "fc5sr/Y6"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :frick_dmca, :pow,
  user: FrickDmca.Users.User,
  repo: FrickDmca.Repo,
  web_module: FrickDmcaWeb

config :frick_dmca, :pow_assent, http_adapter: Assent.HTTPAdapter.Mint

config :kaffy,
  otp_app: :frick_dmca,
  ecto_repo: FrickDmca.Repo,
  router: FrickDmcaWeb.Router

# Import secrets shared by all configs, e.g. API keys.
import_config "config.secret.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
