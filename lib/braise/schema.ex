defmodule Braise.Schema do
  @moduledoc """
  The structured representation of the parse JSON file for
  JSON Schema.
  """

  defstruct [:definitions, :description, :id, :links, :properties, :title, :type, :links]

  @doc"""
  Returns a collection of resources that we can generate adapter
  and model files from. The resource is the combination of a
  name, uri, definition, and response.

  The response represents what should be returned by the
  specific resource, the definition contains specifically what
  each attribute in the response means. We have to later dereference
  the response with the provided definition.
  """
  def resources(schema, collection \\ []) do
    Map.to_list(schema.properties)
    |> resources(schema, collection)
  end

  @doc"""
  Returns a parsed URI from the JSON schema segment that contains
  the root of the API we are trying to build Ember files out of.

  ## Examples

      iex > Braise.Schema.url([%{"href" => "http://bizdev.lol"}])
      {:ok, %URI{authority: "bizdev.lol", fragment: nil, host: "bizdev.lol", path: nil, port: 80, query: nil, scheme: "http", userinfo: nil}

      iex > Braise.Schema.url("imma invalid schema")
      {:error, "Invalid links portion of JSON Schema"}
  """
  def url([%{"href" => uri}]), do: {:ok, URI.parse(uri)}
  def url(_), do: {:error, "Invalid links portion of JSON Schema"}

  defp resources([], _, collection), do: collection
  defp resources([{key, _} | tail], schema, collection) do
    definitions = definition_lookup(schema)

    response = response_lookup(schema, key)
    |> Braise.Dereferencer.dereference(definitions)

    links = links_lookup(schema, key)
    |> Enum.map(fn(link)-> Braise.LinkAction.name(key, link) end)

    {:ok, uri} = url(schema.links)

    new_resource = %Braise.Resource{name: key, url: uri, response: response, links: links}
    resources(tail, schema, collection ++[new_resource])
  end

  defp definition_lookup(schema) do
    %{"definitions" => schema.definitions}
  end

  defp response_lookup(schema, resource_name) do
    lookup(schema, resource_name, "properties")
  end

  defp links_lookup(schema, resource_name) do
    lookup(schema, resource_name, "links")
  end

  defp lookup(schema, resource_name, type) do
    schema.definitions[resource_name][type]
  end
end
