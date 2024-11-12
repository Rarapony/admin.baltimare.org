defmodule BaltimarecmsWeb.UserLoginLive do
  use BaltimarecmsWeb, :live_view
  alias Baltimarecms.Accounts

  def mount(_params, _session, socket) do
    uuid = Phoenix.Flash.get(socket.assigns.flash, :uuid)
    form = to_form(%{"uuid" => uuid}, as: "user")

    socket =
      socket
      |> assign(form: form)
      |> assign(:status, :not_sent)

    {:ok, socket, temporary_assigns: [form: form]}
  end

  def render(assigns) do
    ~H"""
    <div :if={@status == :not_sent} class="mx-auto max-w-md">
      <.header class="text-center">
        Sign In to Your Account
        <:subtitle>No password needed: we'll send you a link!</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="magic_link_form"
        action={~p"/login"}
        phx-update="ignore"
        phx-submit="send-magic-link"
        class="my-0 py-0"
      >
        <.input field={@form[:uuid]} type="text" label="UUID" required /> <div class="error" phx-feedback-for="user[uuid]"></div>
        <:actions>
          <.button
            class="w-full flex place-content-center place-items-center gap-2"
            phx-disable-with="Sending link..."
          >
            Send me a link <.icon name="hero-envelope" />
          </.button>
        </:actions>
      </.simple_form>
    </div>

    <div :if={@status == :sent} class="mx-auto">
      <.header class="text-center">
        Check your notifications!
        <:subtitle>
          We sent you a link to sign in.
        </:subtitle>
      </.header>
    </div>
    """
  end

  def handle_event("send-magic-link", params, socket) do
    %{"user" => %{"uuid" => uuid}} = params

    Accounts.login_or_register_user(uuid)

    socket =
      socket
      |> Phoenix.LiveView.put_flash(
        :info,
        "We've sent a link to the provided UUID."
      )
      |> assign(:status, :sent)

    {:noreply, socket}
  end
end
