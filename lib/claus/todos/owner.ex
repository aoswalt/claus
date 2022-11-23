defmodule Claus.Todos.Owner do
  use Ecto.Schema

  alias Claus.Todos.TodoList

  schema "users" do
    field :name, :string

    has_many :todo_lists, TodoList
  end
end
