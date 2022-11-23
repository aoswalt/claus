defmodule Claus.Todos.TodoList do
  use Ecto.Schema

  alias Claus.Todos.Owner
  alias Claus.Todos.TodoItem

  schema "todo_lists" do
    field :title, :string
    has_many :todo_items, TodoItem

    belongs_to :owner, Owner

    timestamps()
  end
end
