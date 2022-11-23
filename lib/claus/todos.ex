defmodule Claus.Todos do
  import Ecto.Changeset

  alias Claus.Repo
  alias Claus.Todos.TodoItem
  alias Claus.Todos.TodoList

  def create_list(title, owner) do
    owner
    |> Ecto.build_assoc(:todo_lists)
    |> store_list(title)
  end

  defp store_list(%TodoList{} = list, title) do
    list
    |> change(title: title)
    |> validate_length(:title, min: 1, max: 100)
    |> Repo.insert_or_update()
  end

  def delete_list(%TodoList{} = list) do
    list
    |> change(deleted_at: NaiveDateTime.utc_now())
    |> Repo.update()
  end

  def add_item(%TodoList{} = list, text) do
    list
    |> Ecto.build_assoc(:todo_items)
    |> store_item(text)
  end

  defp store_item(%TodoItem{} = item, text) do
    item
    |> change(text: text)
    |> validate_length(:text, min: 1, max: 100)
    |> Repo.insert_or_update()
  end

  def complete_item(%TodoItem{} = item) do
    item
    |> change(completed_at: NaiveDateTime.utc_now())
    |> Repo.update()
  end

  def delete_item(%TodoItem{} = item) do
    item
    |> change(deleted_at: NaiveDateTime.utc_now())
    |> Repo.update()
  end
end
