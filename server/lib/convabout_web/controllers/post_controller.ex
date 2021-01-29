defmodule ConvaboutWeb.PostController do
  use ConvaboutWeb, :controller

  alias Convabout.Core
  alias Convabout.Core.Post

  action_fallback(ConvaboutWeb.FallbackController)

  def index(conn, _params) do
    posts = Core.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    user = Convabout.Accounts.Guardian.Plug.current_resource(conn)
    post_params_with_user = Map.merge(post_params, %{"user_id" => user.id})

    with {:ok, %Post{} = post} <- Core.create_post(post_params_with_user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Core.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Core.get_post!(id)

    with {:ok, %Post{} = post} <- Core.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Core.get_post!(id)

    with {:ok, %Post{}} <- Core.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
