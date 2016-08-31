defmodule Workshop.User do
  use Workshop.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :hashed_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps
  end

  # "@" indicates module attribute and is compiled into this module, but not externally available
  # "~w()" represents a "sidule"
  @allowed_params ~w(name email password password_confirmation)a # a at the end casts these strings as atoms

  # \\ indicates pattern matching and in this context indicates default value if not provided instead = like in php
  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, @allowed_params)
      |> validate_required(@allowed_params) # means all allowed fields are required
      |> update_change(:email, &String.downcase/1) # & shortcut for calling a function on a field passed in /1 indicates it only takes 1 arguments
      # alt # |>update_change(:email, fn email -> String.downcase(email) end)
      |> validate_format(:email, ~r/@/) # reg exp
      |> unique_constraint(:email)
      |> validate_confirmation(:password, message: "must match password")
      |> hash_password()
  end

  defp hash_password(%{changes: %{password: password}, valid?: true} = changeset),
    do: put_change(changeset, :hashed_password, Comeonin.Bcrypt.hashpwsalt(password))
  defp hash_password(changeset), do: changeset

end
