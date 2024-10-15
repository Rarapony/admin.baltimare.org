defmodule BaltimarecmsWeb.AnnouncementHTML do
  use BaltimarecmsWeb, :html

  embed_templates "announcement_html/*"

  @doc """
  Renders a announcement form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def announcement_form(assigns)
end
