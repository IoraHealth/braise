defmodule Braise.Model do
  defstruct [:name, :attributes]
  @moduledoc"""
  Representation of a RESTful resource with a name plus a collection of attributes.
  """

  @doc"""
  Returns a Braise Model with a collection of attributes assigned to the resource
  name.

  ## Examples
  iex > resource = %Braise.Resource{name: "pirate", definition: %{"name" => "booty"}, response: %{"name" => "name"}}
  iex > Braise.Model.parse_from_resource(resource)
  %Braise.Model{name: "pirate", attributes: [%Braise.Attribute{name: "name", type: null, format: null}]}
  """
  def parse_from_resource(resource = %Braise.Resource{}) do
    %Braise.Model{name: resource.name, attributes: dereference_response(resource)}
  end

  defp dereference_response(resource, collection \\ []) do
    {references, non_references} =  Enum.partition(resource.response,  fn(e) ->
      Dict.get(elem(e,1), "$ref")
    end)

    attributes = Enum.map(non_references, fn(non_reference)->
      map_attribute(elem(non_reference, 0), elem(non_reference, 1))
    end)

    Braise.ResourceDefinitionTuples.map(references)
    |> dereference_response(resource.definition, attributes ++ collection)
  end

  defp dereference_response([], _, collection), do: collection
  defp dereference_response([{key, value} | tail], definitions, collection) do
    reference = Dict.get(definitions, value)

    dereference_response(tail, definitions, collection ++ [map_attribute(key, reference)])
  end

  defp map_attribute(key, definition) do
    type = List.to_string(definition["type"])
    type = List.to_string(definition["type"])
    %Braise.Attribute{name: key, type: type, format: definition["format"]}
  end
end
