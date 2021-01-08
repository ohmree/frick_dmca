defmodule FrickDmcaWeb.ModalComponent do
  use FrickDmcaWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="fixed z-1 left-0 top-0 h-full w-full overflow-auto bg-transparent opacity-100"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target="#<%= @id %>"
      phx-page-loading>

      <div class="p-80 w-80 m-14 m-auto  bg-opacity-40 bg-black>
        <%= live_component @socket, @component, @opts %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
