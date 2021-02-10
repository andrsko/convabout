defmodule Convabout.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts_tags, primary_key: false) do
      add(:post_id, references(:posts, on_delete: :delete_all), primary_key: true)
      add(:tag_id, references(:tags, on_delete: :delete_all), primary_key: true)
    end

    create(
      unique_index(:posts_tags, [:post_id, :tag_id], name: :post_id_tag_id_unique_index)
    )

  end
end
