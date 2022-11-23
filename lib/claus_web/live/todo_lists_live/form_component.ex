defmodule ClausWeb.TodoListsLive.FormComponent do
  use ClausWeb, :live_component

  alias Claus.Todos.TodoList

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage stuff records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="todo-list-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :title}} type="text" label="text" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Stuff</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  defp cast(list, params \\ %{}) do
    types = %{title: :string}

    {list, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required([:title])
  end

  @impl Phoenix.LiveComponent
  def update(%{todo_list: list} = assigns, socket) do
    changeset = cast(list)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl Phoenix.LiveComponent
  def handle_event("validate", %{"stuff" => stuff_params}, socket) do
    changeset =
      socket.assigns.stuff
      |> cast(stuff_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"stuff" => stuff_params}, socket) do
    save_stuff(socket, socket.assigns.action, stuff_params)
  end

  defp save_stuff(socket, :edit, todo_list_params) do
    input_schema = [
      title: [:string, required: true]
    ]

    with {:ok, params} <- Claus.normalize(todo_list_params, input_schema),
         {:ok, _list} <- Claus.Todos.change_list_title(socket.assigns.todo_list, params.title) do
      {:noreply,
       socket
       |> put_flash(:info, "List updated successfully")
       |> push_navigate(to: socket.assigns.navigate)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_stuff(socket, :new, stuff_params) do
    case Thing.create_stuff(stuff_params) do
      {:ok, _stuff} ->
        {:noreply,
         socket
         |> put_flash(:info, "Stuff created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
