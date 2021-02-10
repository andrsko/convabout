defmodule Convabout.Repo.Migrations.CreateUniqueIndexTagsName do
  use Ecto.Migration

  def change do
    create(unique_index(:tags, [:name]))
  end
end
