import Claus.Factory

alias Claus.Repo

_users = insert_list(10, :user)

# owner data is a subset of user data
owners = Repo.all(Claus.Todos.Owner)

insert_list(15, :todo_list,
  owner: Enum.random(owners),
  todo_items: fn ->
    build_list(Enum.random(3..10), :todo_item)
  end
)
