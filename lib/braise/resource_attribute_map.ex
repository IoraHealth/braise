defmodule Braise.ResourceAttributeMap do
  def parse_from_resource(resource = %Braise.Resource{}) do
    response    = Braise.ResponseParser.response(resource)
    definitions = Braise.DefinitionParser.definitions(resource)

    dereference_response(response, definitions)
  end

  def dereference_response(response, definitions, dereferenced_response \\ %{})

  def dereference_response([], _, dereferenced_response), do: dereferenced_response

  def dereference_response([{key, value} | tail], definitions, dereferenced_response) do
    reference = Dict.get(definitions, value)
    dereference_response(tail, definitions, Dict.put(dereferenced_response, key, reference))
  end
end
