# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :gurren,
  ecto_repos: [Gurren.Repo]

# Configures the endpoint
config :gurren, GurrenWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7n+Ed4pN8qtc0AQ6QpfNXppA0IUud0SlHdXwhGtZbl097TQsuYRgt+qBebbiK4tv",
  render_errors: [view: GurrenWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Gurren.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
