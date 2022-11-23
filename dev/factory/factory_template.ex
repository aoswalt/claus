defmodule Claus.FactoryTemplate do
  defmacro __using__(_opts \\ []) do
    quote do
      use ExMachina.Ecto, repo: Claus.Repo

      import Claus.FactoryTemplate, only: :functions
    end
  end

  def text(), do: Faker.Lorem.sentence()
  def label(range \\ 1..3), do: Faker.Lorem.words(range) |> Enum.join(" ")
  def title(range \\ 2..5), do: label(range)

  # def tag(), do: Faker.Lorem.words(1..3) |> Enum.join("_")
  # def tags(range \\ 0..3), do: Stream.repeatedly(&tag/0) |> Enum.take(Enum.random(range))

  def boolean(), do: Enum.random([true, false])
  def integer(range \\ 0..3_000), do: Enum.random(range)

  def email(), do: Faker.Internet.email()
end
