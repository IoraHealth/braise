defmodule Braise.Dereferencer do

  def dereference(resources, definitions) do
    {references, non_references} =  Enum.partition(resources,  fn(e) ->
      Dict.get(elem(e,1), "$ref")
    end)
    non_reference_values = Enum.map(non_references, fn({key,value})->
      Map.put(value, "name", key)
    end)

    Braise.ResourceDefinitionTuples.map(references)
    |> dereference(definitions, non_reference_values)
  end

  defp dereference([], _, collection), do: collection
  defp dereference([{key, value} | tail], definitions, collection) do
    dereferenced = Dict.get(definitions, value)
    dereferenced_with_name = Map.put(dereferenced, "name", key)

    dereference(tail, definitions, collection ++ [dereferenced_with_name])
  end

end
