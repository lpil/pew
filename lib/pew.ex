defmodule Pew do
  @moduledoc """
  TODO: Documentation for Pew.

  """

  @doc """
  Start a new Pew supervision tree.

  ## Options

  - `:name` - An atom that the tree will use as a base when
    naming its processes.
  - `:postgrex_options` - A list of options suitable for passing
    to `Postgrex.start_link/1`.

  """
  defdelegate start_link(opts), to: Pew.Supervisor

  @doc """
  Insert a new job into the database for processing by Pew.

  The `conn` argument can be a Postgrex connection pid (as
  returned by `Postgrex.start_link/1`) or the name given to a
  Pew supervision tree (in `Pew.start_link/1`).

  If the Pew tree name is used then the connection cannot be
  used for retrieving jobs for work during the insert. As a
  result it may be preferable to use your own Postgrex connection
  pool.

  """
  defdelegate insert_job(conn, job_type, args, options), to: Pew.SQL
  defdelegate insert_job(conn, job_type, args), to: Pew.SQL
  defdelegate insert_job(conn, job_type), to: Pew.SQL
end
