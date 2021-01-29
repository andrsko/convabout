defmodule ConvaboutWeb.SessionView do
  use ConvaboutWeb, :view

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

  def render("error.json", %{message: message}) do
    %{status: :unauthorized, message: message}
  end
end
