defmodule ClausWeb.TodoListsLive.Show do
  use ClausWeb, :live_view

  alias Claus.Repo
  alias Claus.Todos.TodoItem
  alias Claus.Todos.TodoList

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"todo_list_id" => todo_list_id}, _, socket) do
    title = todo_list_title(todo_list_id)

    {:noreply,
     assign(socket,
       page_title: title,
       todo_list_title: title,
       todo_items: list_todo_items(todo_list_id)
     )}
  end

  defp todo_list_title(todo_list_id) do
    import Ecto.Query

    TodoList
    |> select([l], l.title)
    |> Repo.get!(todo_list_id)
  end

  defp list_todo_items(todo_list_id) do
    import Ecto.Query

    from(i in TodoItem,
      where: i.todo_list_id == ^todo_list_id
    )
    |> Repo.all()
  end
end
