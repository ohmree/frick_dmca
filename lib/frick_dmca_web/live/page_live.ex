defmodule FrickDmcaWeb.PageLive do
  use FrickDmcaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, url: "")}
  end

  @impl true
  def handle_event("update_url", %{"url" => url}, socket) do
    {:noreply, assign(socket, url: url)}
  end
  def handle_event("fetch_song", _, socket) do
    {:noreply, put_flash(socket, :info, "URL is #{socket.assigns.url}")}
  end
end
