defmodule Braise.Model do

  def parse_from_resource(resource = %Braise.Resource{}) do
    response    = Braise.ResponseParser.response(resource)
    definitions = Braise.DefinitionParser.definitions(resource)
    {:ok, name} = Braise.Resource.name(resource)

    %{name: name, attributes: dereference_response(response, definitions)}
  end

  def dereference_response(response, definitions, dereferenced_response \\ [])

  def dereference_response([], _, dereferenced_response), do: dereferenced_response

  def dereference_response([{key, value} | tail], definitions, dereferenced_response) do
    reference = Dict.get(definitions, value)

    dereference_response(tail, definitions, dereferenced_response ++ [map_attribute(key, reference)])
  end

  defp map_attribute(key, definition) do
    type = List.to_string(definition["type"])
    %Braise.Attribute{name: key, type: type, format: definition["format"]}
  end
end
