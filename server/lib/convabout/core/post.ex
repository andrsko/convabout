defmodule Convabout.Core.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:title, :string)
    has_many(:messages, Convabout.Core.Message)
    belongs_to(:user, Convabout.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end
end
