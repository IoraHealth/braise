defmodule Braise.Resource do
  @moduledoc """
  The representation of a single RESTful resource within Braise.
  """
  defstruct [:name, :url, :response, :links]
end
