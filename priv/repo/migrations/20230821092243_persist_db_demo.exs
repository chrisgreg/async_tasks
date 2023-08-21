defmodule AsyncTasks.Repo.Migrations.PersistDbDemo do
  use Ecto.Migration

  def change do
    create table(:travel_data) do
      add :fetched, :boolean
      add :demo, :string
    end
  end
end
