defmodule ConvaboutWeb.ChatController do
  use ConvaboutWeb, :controller

  alias Convabout.Core

  action_fallback(ConvaboutWeb.FallbackController)

  def show(conn, %{"id" => post_id}) do
    messages = Core.list_messages_by_post(post_id)
    render(conn, "show.json", messages: messages)
  end
end
