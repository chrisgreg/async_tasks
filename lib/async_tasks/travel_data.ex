defmodule AsyncTasks.TravelData do
  use Ecto.Schema
  import Ecto.Changeset

  schema "travel_data" do
    field :fetched, :boolean
    field :demo, :string
  end

  def changeset(travel_data, attrs) do
    travel_data
    |> cast(attrs, [:fetched, :demo])
    |> validate_required([:fetched, :demo])
  end
end
