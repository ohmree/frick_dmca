defmodule FrickDmca.Auth.Twitch do
  use Assent.Strategy.OAuth2.Base
  alias Assent.{Config, Strategy.OAuth2}

  @impl true
  def default_config(_config) do
    [
      # The base URL to use for any paths below
      site: "https://api.twitch.tv/helix",
      # Full URL will not use the `:site` option
      authorize_url: "https://id.twitch.tv/oauth2/authorize",
      token_url: "https://id.twitch.tv/oauth2/token",
      user_url: "/users",
      authorization_params: [scope: "user:read:email"],
      auth_method: :client_secret_post
    ]
  end

  @impl true
  def normalize(_config, user) do
    {
      :ok,
      # Conformed to https://openid.net/specs/openid-connect-core-1_0.html#rfc.section.5.1
      %{
        "sub" => user["id"],
        "preferred_username" => user["display_name"],
        "name" => user["login"],
        "email" => user["email"],
        "picture" => user["profile_image_url"]
      }
    }
  end

  @impl true
  def fetch_user(config, access_token) do
    with {:ok, client_id} <- Config.fetch(config, :client_id) do
      headers = [{"Client-Id", client_id}]
      {:ok, user} = OAuth2.fetch_user(config, access_token, [], headers)
      [user] = user["data"]
      {:ok, user}
    end
  end
end
