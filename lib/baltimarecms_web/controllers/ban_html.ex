defmodule BaltimarecmsWeb.BanHTML do
  use BaltimarecmsWeb, :html

  embed_templates "ban_html/*"

  @doc """
  Renders a ban form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def ban_form(assigns)
end
