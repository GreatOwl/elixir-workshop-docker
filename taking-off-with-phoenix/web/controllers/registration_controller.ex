defmodule Workshop.RegistrationController do
  use Workshop.Web, :controller

  alias Workshop.User

  # START this is implemented elsewhere
#  def init(:new) #predefined?
#  def call(conn, :new) do
#  end
#
#  def action(conn, []) do # For example this function is overloading Workshop.Web.controller
#    user = conn.assigns[:user] # this we added
#    apply(__MODULE__, :new, [conn, conn.params]) # what happens by default
#  end
  # END this is implemented elsewhere


#  def new(conn, _params) do
#    render conn, "new.htm" # double quoted string is a binary string, single quoute is a linked set of characters
#  end


    def new(conn, _params) do
      changeset = User.changeset(%User{})
      render conn, "new.html", changeset: changeset
    end

    def create(conn, %{"user" => user_params}) do
      changeset = User.changeset(%User{}, user_params)

      case Repo.insert(changeset) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "Success")
          |> put_session(:current_user_id, user.id)
          |> redirect(to: page_path(conn, :index))
        {:error, changeset} ->
          conn
          |> render("new.html", changeset: changeset)
      end
    end
end