defmodule GurrenWeb.Helpers.Auth do
  alias Gurren.Accounts
  import Plug.Conn
  import Phoenix.Controller

  def signed_in?(conn) do
    # Lazy Check for User, used to show menu options
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    session_token = Plug.Conn.get_session(conn, :session_token)
    user_id && session_token
  end

  def signed_in?(conn, _args) do
    # Hard Check for User, used on Plugs/page auth
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    session_token = Plug.Conn.get_session(conn, :session_token)
    if user_id && session_token do
      try do
        session = Accounts.get_session!(session_token)
        user = Accounts.get_user!(user_id)
        if session.user_id === user_id do
          conn
          |> assign(:current_user, user)
          |> assign(:current_session, session)
        else
          invalid_session(conn)
        end
      rescue
        _ -> invalid_session(conn)
      end
    else
      general_error(conn, "You need to be signed in to access that page.")
    end
  end

  def current_user(conn) do
      Plug.Conn.get_session(conn, :current_user)
  end

  def general_error(conn, error \\ "Unknown Error. Please try again.") do
   conn
   |> put_flash(:error, error)
   |> redirect(to: "/")
   |> halt()
  end

  defp clean_session(conn) do
    Plug.Conn.delete_session(conn, :current_user_id)
    Plug.Conn.delete_session(conn, :session_token)
  end

  defp invalid_session(conn, error \\ "Invalid Session. Please sign in") do
    conn
    |> clean_session
    |> general_error(error)
  end

end
