defmodule Pew.Job do
  @moduledoc """
  A behaviour for creating Jobs.

  """

  @type args :: map

  @callback run(args()) :: :ok
end
