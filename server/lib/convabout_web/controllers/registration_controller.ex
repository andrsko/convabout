defmodule ConvaboutWeb.RegistrationController do
  use ConvaboutWeb, :controller

  alias Convabout.Repo

  alias Convabout.{Accounts.User, Accounts.Guardian}

  def sign_up(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _claims} = Guardian.encode_and_sign(user)

        conn
        |> put_status(:created)
        |> render("success.json", user: user, jwt: jwt)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ConvaboutWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end
end
