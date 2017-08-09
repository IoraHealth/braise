defmodule Braise.JsonPointer do

  def lookup(pointer, definitions) do
    lookup(String.split(pointer, "/"), definitions, definitions)
  end

  defp lookup([], definition, _) do
    definition
  end

  # back to root
  defp lookup(["#"|tail], _, definitions_root) do
    lookup(tail, definitions_root, definitions_root)
  end

  # ignore (perhaps a leading "/" ???)
  defp lookup([""|tail], current_definitions, definitions_root) do
    lookup(tail, current_definitions, definitions_root)
  end

  # lookup in current
  defp lookup([key|tail], current_definitions, definitions_root) do
    lookup(tail, Map.get(current_definitions, key), definitions_root)
  end

end
