defmodule ConvaboutWeb.TagController do
    use ConvaboutWeb, :controller
  
    alias Convabout.Core
    alias Convabout.Core.Tag
  
    action_fallback(ConvaboutWeb.FallbackController)
  
    def trending(conn, _params) do
      tags = Core.list_trending_tags()
      render(conn, "trending.json", tags: tags)
    end
  end
  