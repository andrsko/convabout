defmodule Convabout.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add(:body, :text)
      add(:post_id, references(:posts))

      timestamps()
    end
  end
end
