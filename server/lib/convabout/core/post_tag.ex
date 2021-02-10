defmodule Convabout.Core.PostTag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "posts_tags" do
    belongs_to(:post, Convabout.Core.Post)
    belongs_to(:tag, Convabout.Core.Tag)
  end

  @doc false
  def changeset(post_tag, attrs) do
    post_tag
    |> cast(attrs, [:post_id, :tag_id])
    |> validate_required([:post_id, :tag_id])
  end
end
