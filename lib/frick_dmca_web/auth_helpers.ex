defmodule FrickDmcaWeb.AuthHelpers do
  @moduledoc "Authentication helper functions"

  alias FrickDmca.Users.User
  alias Phoenix.LiveView.Socket
  alias Pow.Store.CredentialsCache

  @cache_backend Application.compile_env!(:frick_dmca, [:pow, :cache_store_backend])

  @doc """
  Retrieves the currently-logged-in user from the Pow credentials cache.
  """
  @spec get_current_user(
          socket :: Socket.t(),
          session :: map()
        ) :: %User{} | nil

  def get_current_user(socket, session)

  def get_current_user(socket, %{"frick_dmca_auth" => signed_token}) do
    conn = struct!(Plug.Conn, secret_key_base: socket.endpoint.config(:secret_key_base))
    salt = Atom.to_string(Pow.Plug.Session)
    with {:ok, token} <- Pow.Plug.verify_token(conn, salt, signed_token, [otp_app: :frick_dmca]),
         {user, _metadata} <- CredentialsCache.get([backend: @cache_backend, otp_app: :frick_dmca], token) do
      user
    else
      _any -> nil
    end
  end

  def get_current_user(_, _), do: nil
end
