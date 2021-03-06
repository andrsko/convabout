defmodule ConvaboutWeb.ChatChannel do
  use ConvaboutWeb, :channel

  alias Convabout.Core

  @impl true
  def join("chat:" <> _room, _payload, socket) do
    # if authorized?(payload) do
    send(self(), :after_join)
    {:ok, socket}
    # else
    #  {:error, %{reason: "unauthorized"}}
    # end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # @impl true
  # def handle_in("ping", payload, socket) do
  #  {:reply, {:ok, payload}, socket}
  # end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    "chat:" <> post_id = socket.topic
    user = socket.assigns[:user]

    # create message
    {:ok, message} =
      payload
      |> Map.merge(%{"post_id" => post_id, "user_id" => user.id})
      |> Core.create_message()

    # broadcast created message
    msg = Map.merge(message, %{username: user.username})

    broadcast(socket, "shout", %{
      id: msg.id,
      body: msg.body,
      inserted_at: msg.inserted_at,
      username: msg.username
    })

    {:noreply, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    "chat:" <> post_id = socket.topic

    Core.list_messages_by_post(post_id)
    |> Enum.each(fn msg ->
      push(socket, "shout", %{
        id: msg.id,
        body: msg.body,
        inserted_at: msg.inserted_at,
        username: msg.user.username
      })
    end)

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
