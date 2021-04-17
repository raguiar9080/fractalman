defmodule GurrenWeb.RoomChannel do
  use Phoenix.Channel
  require Logger

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    # Create or subscribe to child room
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"msg" => msg, "author" => author}, socket) do
    Logger.debug "Message: #{msg}: #{author}"
    # Broadcast with user info?
    broadcast! socket, "new_msg", %{body: msg, author: author}
    {:noreply, socket}
  end

  def handle_in("small", %{"time" => time} = payload, socket) do
    show_delay(time)
    show_delay2(time)
    broadcast! socket, "small_reply", %{body: payload}
    #push socket, "small_reply", %{"small response that will only be msgpacked" => true}
    {:noreply, socket}
  end

  def handle_in("small", payload, socket) do
    broadcast! socket, "small_reply", %{body: payload}
    {:noreply, socket}
  end

  def handle_in("large", payload, socket) do
    broadcast! socket, "large_reply", %{body: payload}
    #push socket, "large_reply", %{"large response that will be msgpacked+gzipped" =>  1..1000 |> Enum.map(fn _ -> 1000 end) |> Enum.into([])}
    {:noreply, socket}
  end

  def show_delay(""), do: true
  def show_delay(time), do: Logger.debug "Delay: #{get_timestamp() - String.to_integer(time)}"

  def show_delay2(""), do: true
  def show_delay2(time), do: Logger.debug "Delay: #{get_timestamp2() - String.to_integer(time)}"
  defp get_timestamp() do
    {mega, sec, micro} = :os.timestamp()
    (mega*1000000 + sec)*1000 + round(micro/1000)
  end

  defp get_timestamp2(), do: :os.system_time() / 1000000

end
