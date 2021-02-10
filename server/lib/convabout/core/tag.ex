defmodule Convabout.Core.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name]}

  schema "tags" do
    field(:name, :string, unique: true)
    many_to_many(:posts, Convabout.Core.Post, join_through: "posts_tags", on_replace: :delete)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
