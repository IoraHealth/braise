defmodule Braise.Dereferencer do

  def dereference(resources, definitions) when is_map(resources) do
    dereference(Map.to_list(resources), definitions)
    |> Enum.map(fn(m)->
      [{a,b}] = Map.to_list(m)
      Dict.put(b, "name", a)
    end)
  end

  def dereference(resources, definitions) when is_list(resources) do
    dereference(resources, definitions, [])
  end

  def dereference(resource, _) do
    resource
  end

  defp dereference([], _, collection), do: collection
  defp dereference([{key, %{"$ref" => reference} } | tail], definitions, collection) do
    definition_key = reference_to_definition_key(reference)
    dereferenced = Dict.get(definitions, definition_key)

    dereference([{key, dereferenced} | tail], definitions, collection)
  end

  defp dereference([{key, value} | tail], definitions, collection) when is_map(value) do
    dereferenced = dereference(Map.to_list(value), definitions, [])
    |> list_of_maps_to_map
    dereferenced_with_name = %{key => dereferenced}

    dereference(tail, definitions, collection ++ [dereferenced_with_name])
  end

  defp dereference([{key, value} | tail], definitions, collection) do
    dereferenced_with_name = %{key => value}

    dereference(tail, definitions, collection ++ [dereferenced_with_name])
  end

  defp reference_to_definition_key(reference) do
    regex = ~r/\/definitions\/.*\/definitions\/(?<attribute>.*)/

    Regex.named_captures(regex, reference)
    |> Dict.get("attribute")
  end

  # THIS IS SOOO GROSS
  def list_of_maps_to_map(list_of_maps) do
    x = Enum.map(list_of_maps, fn(a_map)->
      Map.to_list(a_map)
    end)
    f = List.first(x)
    y = if is_list(f) do
      Enum.map(x, &List.first/1)
    else
      x
    end
    Enum.into(y, %{})
  end

end
