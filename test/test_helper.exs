ExUnit.start()

defmodule Support.DatabaseHelpers do
  def postgrex_options do
    [
      hostname: "localhost",
      username: "postgres",
      password: "postgres",
      database: "pew_test"
    ]
  end

  def new_connection(_) do
    conn = Pew.SQL.new_database_connection!(postgrex_options())
    {:ok, conn: conn}
  end

  def setup_database(ctx) do
    :ok = Pew.SQL.setup_database(ctx.conn)
  end

  def truncate_jobs(ctx) do
    Postgrex.query!(ctx.conn, "TRUNCATE pew_jobs", [])
    :ok
  end

  def drop_jobs_table(ctx) do
    Postgrex.query!(ctx.conn, "DROP TABLE IF EXISTS pew_jobs", [])
    :ok
  end

  def table_exists?(conn, table) do
    sql = """
    SELECT EXISTS (
      SELECT 1
      FROM   information_schema.tables
      WHERE  table_name = '#{table}'
    );
    """

    %{rows: [[exists]]} = Postgrex.query!(conn, sql, [])
    exists
  end

  def list_jobs(conn) do
    sql = """
    SELECT * FROM pew_jobs;
    """
    %{columns: columns, rows: rows} = Postgrex.query!(conn, sql, [])
    atom_columns = Enum.map(columns, &String.to_atom/1)
    Enum.map(rows, fn row ->
      atom_columns |> Enum.zip(row) |> Enum.into(%{})
    end)
  end
end
