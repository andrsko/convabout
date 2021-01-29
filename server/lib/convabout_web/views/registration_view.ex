defmodule ConvaboutWeb.RegistrationView do
  use ConvaboutWeb, :view

  def render("success.json", %{user: user, jwt: jwt}) do
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
end
