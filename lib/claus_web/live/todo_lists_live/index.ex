defmodule ClausWeb.TodoListsLive.Index do
  use ClausWeb, :live_view

  alias Claus.Repo
  alias Claus.Todos.TodoList

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :todo_lists, list_todo_lists())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo List")
    |> assign(:todo_list, Repo.get!(TodoList, id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo List")
    |> assign(:todo_list, %TodoList{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todo Lists")
    |> assign(:todo_lsit, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    # stuff = Thing.get_stuff!(id)
    # {:ok, _} = Thing.delete_stuff(stuff)

    {:noreply, assign(socket, :todo_lists, list_todo_lists())}
  end

  defp list_todo_lists() do
    Repo.all(TodoList)
  end
end
