defmodule ConvaboutWeb.SessionController do
  use ConvaboutWeb, :controller

  alias Convabout.{Accounts, Accounts.Guardian}

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
end
