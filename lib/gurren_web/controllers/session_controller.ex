defmodule GurrenWeb.SessionController do
  use GurrenWeb, :controller

  alias Gurren.Accounts
  alias Gurren.Accounts.Session

  plug :signed_in? when action in [:index, :show, :edit, :update, :delete]

  def index(conn, _params) do
    sessions = Accounts.list_sessions()
    render(conn, "index.html", sessions: sessions)
  end

  def new(conn, _params) do
    changeset = Accounts.change_session(%Session{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => auth_params}) do
    user = Accounts.get_by_username(auth_params["username"])
    case Comeonin.Bcrypt.check_pass(user, auth_params["password"]) do
      {:ok, user} ->
        [user_agent] = Plug.Conn.get_req_header(conn, "user-agent")
        case Accounts.create_session(%{user_agent: user_agent, user_id: user.id}) do
          {:ok, session} ->
            conn
            |> put_session(:current_user_id, user.id)
            |> put_session(:current_user, user)
            |> put_session(:session_token, session.id)
            |> put_flash(:info, "Signed in successfully.")
            |> redirect(to: "/")
          {:error, _} ->
            conn
            |> put_flash(:error, "There was a problem creating your session")
            |> render("new.html")
        end
      {:error, _} ->
        conn
        |> put_flash(:error, "There was a problem with your username/password")
        |> render("new.html")
    end
  end

  def show(conn, %{"id" => id}) do
    session = Accounts.get_session!(id)
    render(conn, "show.html", session: session)
  end

  def edit(conn, %{"id" => id}) do
    session = Accounts.get_session!(id)
    changeset = Accounts.change_session(session)
    render(conn, "edit.html", session: session, changeset: changeset)
  end

  def update(conn, %{"id" => id, "session" => session_params}) do
    session = Accounts.get_session!(id)

    case Accounts.update_session(session, session_params) do
      {:ok, session} ->
        conn
        |> put_flash(:info, "Session updated successfully.")
        |> redirect(to: session_path(conn, :show, session))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render(conn, "edit.html", session: session, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => "logout"}) do
    session_id = Plug.Conn.get_session(conn, :session_token)
    session = Accounts.get_session!(session_id)
    {:ok, _session} = Accounts.delete_session(session)

    conn
    |> delete_session(:current_user_id)
    |> delete_session(:current_user)
    |> delete_session(:session_token)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: "/")
  end

  def delete(conn, %{"id" => id}) do
    session = Accounts.get_session!(id)
    {:ok, _session} = Accounts.delete_session(session)

    conn
    |> put_flash(:info, "Session deleted successfully.")
    |> redirect(to: "/")
  end

end
