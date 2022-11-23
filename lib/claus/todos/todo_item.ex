defmodule Claus.Todos.TodoItem do
  use Ecto.Schema

  alias Claus.Todos.TodoList

  schema "todo_items" do
    belongs_to :todo_list, TodoList
    field :text, :string
    field :completed_at, :naive_datetime

    timestamps()
  end
end
