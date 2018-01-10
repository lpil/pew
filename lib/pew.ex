defmodule Pew do
  @moduledoc """
  TODO: Documentation for Pew.

  """

  defdelegate start_link(opts), to: Pew.Supervisor
end
