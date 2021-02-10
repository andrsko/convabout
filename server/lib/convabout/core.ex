defmodule Convabout.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias Convabout.Repo

  alias Convabout.Core.Post
  alias Convabout.Core.Tag
  alias Convabout.Core.Message

  alias Convabout.Utils

  def list_messages_by_post(post_id) do
    qry =
      from(m in Message,
        where: m.post_id == ^post_id,
        preload: [:user],
        order_by: [asc: m.inserted_at]
      )

    Repo.all(qry)
  end

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    {:ok, postgrex_result} =
      Repo.query(
        "SELECT posts_with_tags_usernames.*, 
                posts_with_message_counts.* 
        FROM   (SELECT posts_with_tags.*, 
                        users.username 
                FROM   (SELECT posts.*, 
                                coalesce(
                                  json_agg(tags)FILTER (WHERE tags.id IS NOT NULL),
                                  '[]')
                                  AS tags  
                        FROM   posts 
                                LEFT JOIN posts_tags 
                                      ON posts.id = posts_tags.post_id 
                                LEFT JOIN tags 
                                      ON posts_tags.tag_id = tags.id 
                        GROUP  BY posts.id) posts_with_tags 
                        LEFT JOIN users 
                              ON posts_with_tags.user_id = users.id) 
                posts_with_tags_usernames 
                LEFT JOIN (SELECT posts.id, 
                                  Count(messages.id) AS message_count 
                          FROM   posts 
                                  LEFT JOIN messages 
                                        ON posts.id = messages.post_id 
                          GROUP  BY posts.id) posts_with_message_counts 
                      ON posts_with_tags_usernames.id = posts_with_message_counts.id;"
                  )

    Utils.postgrex_result_to_map(postgrex_result)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Repo.get!(Post, id)
    |> Repo.preload([:user])
    |> Repo.preload([:tags])    
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    tags = attrs["tags"]
    Map.delete(attrs, "tags")

    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, post} -> Repo.preload(post, [:tags]) |> create_tags(tags)
      error -> error
    end
  end

  def create_tags(post, tags \\ "") do
    String.split(tags, ",")
    |> Enum.each(fn tag_name ->
      create_tag(post, %{"name"=>String.trim(tag_name)})
      end)

    {:ok, Repo.preload(post, [:user, :tags])}
  end

  def create_tag(post, attrs \\ %{}) do
    existing_tag = Repo.get_by(Tag, name: attrs["name"])

    if existing_tag  != nil do
      Repo.preload(existing_tag, [:posts])|> create_tag_post(post)
    else
      %Tag{}
      |> Tag.changeset(attrs)
      |> Repo.insert()
      |> case do
        {:ok, new_tag} -> Repo.preload(new_tag, [:posts])|> create_tag_post(post)
        error -> error
      end
    end
  end

  def create_tag_post(tag, post) do
    changeset = Ecto.Changeset.change(post) |> Ecto.Changeset.put_assoc(:tags, [tag])
    Repo.update!(changeset)
  end

  def list_trending_tags() do
    {:ok, postgrex_result} = Repo.query(
      "SELECT tags.id, tags.name, COUNT(tag_id)
      FROM tags
      INNER JOIN (
        SELECT posts_tags.tag_id
        FROM posts
        INNER JOIN posts_tags ON posts.id=posts_tags.post_id
        ORDER BY inserted_at DESC
        LIMIT 1000) last_posts_tags
      ON tags.id = last_posts_tags.tag_id
      GROUP BY (tags.id)
      ORDER BY count DESC
      LIMIT 10;")

  Utils.postgrex_result_to_map(postgrex_result)
end

def list_posts_of_tag(id) do
  {:ok, postgrex_result} = Repo.query(
    "SELECT posts_with_tags_usernames.*, 
        posts_with_message_counts.* 
    FROM   (SELECT posts_with_tags.*, 
                users.username 
        FROM   (SELECT posts.*, 
                        json_agg(tags) AS tags 
                FROM   posts 
                        LEFT JOIN posts_tags 
                              ON posts.id = posts_tags.post_id 
                        LEFT JOIN tags 
                              ON posts_tags.tag_id = tags.id 
                WHERE  posts.id IN(SELECT posts.id 
                                    FROM   posts 
                                          INNER JOIN posts_tags 
                                                  ON posts.id = 
                                                      posts_tags.post_id 
                                    WHERE  tag_id = $1) 
                GROUP  BY posts.id) posts_with_tags 
                LEFT JOIN users 
                      ON posts_with_tags.user_id = users.id) 
        posts_with_tags_usernames 
        LEFT JOIN (SELECT posts.id, 
                          Count(messages.id) AS message_count 
                  FROM   posts 
                          LEFT JOIN messages 
                                ON posts.id = messages.post_id 
                  GROUP  BY posts.id) posts_with_message_counts 
              ON posts_with_tags_usernames.id = posts_with_message_counts.id;",
              [String.to_integer(id)])

  Utils.postgrex_result_to_map(postgrex_result)
end

def tag_id_from_name(name) do
  tag = Repo.get_by(Tag, name: name)
  tag.id
end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
