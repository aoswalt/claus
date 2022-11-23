defmodule Claus.Repo do
  use Ecto.Repo,
    otp_app: :claus,
    adapter: Ecto.Adapters.Postgres

  require Ecto.Query

  def fetch_one(queryable) do
    case all(queryable) do
      [record] -> {:ok, record}
      [] -> {:error, :not_found}
    end
  end

  def fetch(queryable, id) do
    queryable
    |> query_for_get(id)
    |> fetch_one()
  end

  def fetch_by(queryable, clauses) do
    queryable
    |> query_for_get_by(clauses)
    |> fetch_one()
  end

  # from Ecto
  defp query_for_get(queryable, id) do
    query = Ecto.Queryable.to_query(queryable)
    schema = assert_schema!(query)

    case schema.__schema__(:primary_key) do
      [pk] ->
        Ecto.Query.from(x in query, where: field(x, ^pk) == ^id)

      pks ->
        raise ArgumentError,
              "Ecto.Repo.get/2 requires the schema #{inspect(schema)} " <>
                "to have exactly one primary key, got: #{inspect(pks)}"
    end
  end

  # from Ecto
  defp query_for_get_by(queryable, clauses) do
    Ecto.Query.where(queryable, [], ^Enum.to_list(clauses))
  end

  # from Ecto
  defp assert_schema!(%{from: %{source: {_source, schema}}}) when schema != nil, do: schema

  # from Ecto
  defp assert_schema!(query) do
    raise Ecto.QueryError,
      query: query,
      message: "expected a from expression with a schema"
  end

  def transact(fun, opts \\ []) do
    transaction(
      fn repo ->
        Function.info(fun, :arity)
        |> case do
          {:arity, 0} -> fun.()
          {:arity, 1} -> fun.(repo)
        end
        |> case do
          {:ok, result} -> result
          {:error, reason} -> repo.rollback(reason)
        end
      end,
      opts
    )
  end
end
