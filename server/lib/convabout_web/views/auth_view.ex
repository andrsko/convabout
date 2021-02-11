defmodule ConvaboutWeb.AuthView do
  use ConvaboutWeb, :view

  def render("sign_up.json", %{user: user, jwt: jwt}) do
    %{
      status: :ok,
      data: %{
        token: jwt,
        username: user.username
      },
      message: """
        Now you can sign in using your email and password at /api/sign_in. You will receive JWT token.
        Please put this token into Authorization header for all authorized requests.
      """
    }
  end

  def render("sign_in.json", %{user: user, jwt: jwt}) do
    %{
      status: :ok,
      data: %{
        token: jwt,
        username: user.username
      },
      message:
        "You are successfully logged in! Add this token to authorization header to make authorized requests."
    }
  end

  def render("set_password.json", %{message: message}) do
    %{status: :ok, message: message}
  end

  def render("error.json", %{message: message}) do
    %{status: :unauthorized, message: message}
  end
end
