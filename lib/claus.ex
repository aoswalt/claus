defmodule Claus do
  @moduledoc """
  Claus keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # https://medium.com/very-big-things/towards-maintainable-elixir-the-anatomy-of-a-core-module-b7372009ca6d
  # https://medium.com/very-big-things/towards-maintainable-elixir-the-core-and-the-interface-c267f0da43

  def validate(true, _error_reason), do: :ok
  def validate(false, error_reason), do: {:error, error_reason}

  def authorize(condition), do: validate(condition, :unauthorized)

  def normalize(params, schema) do
    import Ecto.Changeset

    keys = Enum.map(schema, &elem(&1, 0))

    {types, required} =
      Enum.reduce(schema, {%{}, []}, fn {k, args}, {types, required} ->
        {type, opts} =
          case args do
            [type | opts] when is_atom(type) -> {type, opts}
            type when is_atom(type) -> {type, []}
          end

        types = Map.put(types, k, type)
        required = if Keyword.get(opts, :required, false), do: [k | required], else: required

        {types, required}
      end)

    {%{}, types}
    |> cast(params, keys)
    |> validate_required(required)
    |> apply_action(:normalize)
  end

  def foo(params) do
    input_schema = [
      email: [:string, required: true],
      password: [:string, required: true]
    ]

    case normalize(params, input_schema) do
      {:ok, normalized_input} -> IO.inspect(normalized_input)
      {:error, changeset} -> IO.inspect(changeset)
    end
  end
end
