defmodule Braise.Dereferencer do

  @doc"""
  Given a map of resources and definitions apply the definitions and to dereference any "$ref"s
  Return the dereferenced map of resources

  ## Examples
      iex > resources = %{"first_name" => %{"format" => nil, "name" => "first_name", "type" => ["pirate"]},"guid" => %{"$ref" => "/definitions/pirate/definitions/guid"}}
      iex > definitions = %{"definitions" => %{"pirate" => %{"definitions" => %{"guid" => %{"type" => ["string"]}}}}}
      iex > Braise.Dereferencer.dereference(resources, definitions)
      %{"first_name" => %{"format" => nil, "name" => "first_name", "type" => ["pirate"]}, "guid" => %{"type" => ["string"]}}
  """
  def dereference(resources, definitions) do
    dereference(Map.to_list(resources), definitions, [])
    |> Enum.into(%{})
  end


  defp dereference([], _, collection), do: collection

  defp dereference([{key, %{"$ref" => reference} } | tail], definitions, collection) do
    dereferenced = Braise.JsonPointer.lookup(reference, definitions)
    dereference(tail, definitions, collection ++ [{key, dereferenced}])
  end

  defp dereference([{key, value} | tail], definitions, collection) when is_map(value) do
    dereference(tail, definitions, collection ++ [{key, value}])
  end

end
