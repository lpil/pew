defmodule Pew do
  @moduledoc """
  TODO: Documentation for Pew.

  """

  defdelegate child_spec(args), to: Pew.Supervisor
  defdelegate start_link(args), to: Pew.Supervisor

  def enqueue(name, job_module, args) do
    _repo = Pew.Manager.get_repo(name)
    # TODO: enqueue yo
  end
end
