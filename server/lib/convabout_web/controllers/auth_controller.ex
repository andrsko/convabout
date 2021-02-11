defmodule ConvaboutWeb.AuthController do
    use ConvaboutWeb, :controller
  
    alias Convabout.Repo
  
    alias Convabout.{Accounts, Accounts.User, Accounts.Guardian}
  
    def sign_up(conn, %{"user" => user_params}) do
      changeset = User.changeset(%User{}, user_params)
  
      case Repo.insert(changeset) do
        {:ok, user} ->
          {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
  
          conn
          |> put_status(:created)
          |> render("sign_up.json", user: user, jwt: jwt)
  
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> put_view(ConvaboutWeb.ChangesetView)
          |> render("error.json", changeset: changeset)
      end
    end

    def sign_in(conn, %{"session" => %{"username" => username, "password" => password}}) do
      case Accounts.authenticate_user(username, password) do
        {:ok, user} ->
          {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
  
          conn
          |> render("sign_in.json", user: user, jwt: jwt)
  
        {:error, _reason} ->
          conn
          |> put_status(401)
          |> render("error.json", message: "Could not login")
      end
    end

    def set_password(conn, %{"password" => password}) do
      user = Guardian.Plug.current_resource(conn)
      changeset = User.set_password(user, password)
  
      case Repo.update(changeset) do
        {:ok, _user} ->
          render(conn, "set_password.json", message: "Password is set successfully")
  
        {:error, _changeset} ->
          conn
          |> put_status(422)
          |> render("error.json", message: "Could not set password")
      end
    end
  end