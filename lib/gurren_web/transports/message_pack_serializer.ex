defmodule GurrenWeb.Transports.MessagePackSerializer do
  @moduledoc false
  @behaviour Phoenix.Transports.Serializer

  alias Phoenix.Socket.Reply
  alias Phoenix.Socket.Message
  alias Phoenix.Socket.Broadcast

  # only gzip data above 1K
  @gzip_threshold 1024

  def fastlane!(%Broadcast{} = msg) do
    {:socket_push, :binary, pack_data(%Message{
      topic: msg.topic,
      event: msg.event,
      payload: msg.payload
    })}
  end

  def encode!(%Reply{} = reply) do
    packed = pack_data(%Message{
      topic: reply.topic,
      event: "phx_reply",
      ref: reply.ref,
      payload: %{status: reply.status, response: reply.payload}
    })
    {:socket_push, :binary, packed}
  end

  def encode!(%Message{} = msg) do
    {:socket_push, :binary, pack_data(msg)}
  end

  def decode!(message, _opts) do
    [join_ref, ref, topic, event, payload | _] = Poison.decode!(message)
    %Phoenix.Socket.Message{
      topic: topic,
      event: event,
      payload: payload,
      ref: ref,
      join_ref: join_ref,
    }
  end

  defp pack_data(%Message{} = msg) do
    msg
    |> Map.take([:topic, :event, :payload, :ref])
    |> Msgpax.pack!()
    |> gzip_data()
  end

  defp gzip_data(data), do: gzip_data(data, :erlang.iolist_size(data))

  defp gzip_data(data, size) when size < @gzip_threshold, do: data
  defp gzip_data(data, _size), do: :zlib.gzip(data)
end
