defmodule Convabout.Core.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :body, :inserted_at]}

  schema "messages" do
    field(:body, :string)
    belongs_to(:post, Convabout.Core.Post)
    belongs_to(:user, Convabout.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :post_id, :user_id])
    |> validate_required([:body, :post_id, :user_id])

    # |> put_assoc(:post, attrs["post"])
  end
end
