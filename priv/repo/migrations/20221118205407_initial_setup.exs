defmodule Claus.Repo.Migrations.InitialSetup do
  use Ecto.Migration

  def change do
    execute "create extension if not exists pg_stat_statements", ""

    alter table(:users) do
      add :name, :text, null: false
    end

    create table(:todo_lists) do
      add :title, :text, null: false
      add :owner_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create table(:todo_items) do
      add :text, :text, null: false
      add :todo_list_id, references(:todo_lists, on_delete: :delete_all), null: false
      add :completed_at, :naive_datetime

      timestamps()
    end
  end
end
