defmodule ConvaboutWeb.PostView do
  use ConvaboutWeb, :view
  alias ConvaboutWeb.PostView

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post_excerpt.json")}
  end

  def render("posts_of_tag.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post_excerpt.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post_excerpt.json", %{post: post}) do
    %{
      id: post.id,
      title: post.title,
      inserted_at: post.inserted_at,
      updated_at: post.updated_at,
      username: post.username,
      message_count: post.message_count,
      tags: post.tags,
    }
  end

  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      title: post.title,
      inserted_at: post.inserted_at,
      updated_at: post.updated_at,
      username: post.user.username,
      tags: post.tags,
    }
  end
end
