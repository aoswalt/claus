defmodule Claus.Factory do
  use Claus.FactoryTemplate

  def user_factory() do
    %Claus.Accounts.User{
      name: label(),
      email: email(),
      hashed_password: sequence("hashed-")
    }
  end

  def owner_factory() do
    %Claus.Accounts.User{
      name: label(),
    }
  end

  def todo_item_factory() do
    %Claus.Todos.TodoItem{
      text: text(),
    }
  end

  def todo_list_factory() do
    %Claus.Todos.TodoList{
      title: title()
    }
  end

  # def tag_factory(_) do
  #   tag()
  # end
end
