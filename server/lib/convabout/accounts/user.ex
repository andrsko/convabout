defmodule Convabout.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:username, :string, unique: true)
    field(:password, :string)

    timestamps()
  end

  alias Argon2

  @generated_password_length 16

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required(:username)
    |> validate_format(:username, ~r/^\w+$/)
    |> validate_length(:username, max: 15)
    |> unique_constraint(:username)
    |> generate_password_if_blank()
    |> put_password_hash()
  end

  defp generate_password_if_blank(%Ecto.Changeset{changes: %{password: _}} = changeset) do
    changeset
  end

  defp generate_password_if_blank(%Ecto.Changeset{valid?: true} = changeset) do
    change(changeset, password: random_string(@generated_password_length))
  end

  defp generate_password_if_blank(changeset), do: changeset

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.encode64() |> binary_part(0, length)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
