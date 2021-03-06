defmodule ConvaboutWeb.TagView do
    use ConvaboutWeb, :view
    alias ConvaboutWeb.TagView
  
    def render("trending.json", %{tags: tags}) do
      %{data: render_many(tags, TagView, "tag.json")}
    end
  
    def render("tag.json", %{tag: tag}) do
      %{
        id: tag.id,
        name: tag.name,
        count: tag.count
      }
    end
  end
  