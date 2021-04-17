defmodule Gurren.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset


  schema "sessions" do
    field :user_agent, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:user_agent, :user_id])
    |> validate_required([:user_agent, :user_id])
  end
end
