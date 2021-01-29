defmodule ConvaboutWeb.MessageView do
  use ConvaboutWeb, :view
  alias ConvaboutWeb.MessageView

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      body: message.body,
      inserted_at: message.inserted_at,
      username: message.user.username
    }
  end
end
