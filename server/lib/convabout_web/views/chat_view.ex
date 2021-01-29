defmodule ConvaboutWeb.ChatView do
  use ConvaboutWeb, :view
  alias ConvaboutWeb.MessageView

  def render("show.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message.json")}
  end
end
