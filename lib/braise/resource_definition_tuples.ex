defmodule Braise.ResourceDefinitionTuples do
  @moduledoc """
  Provides a mapping between the response attributes of
  a RESTful resource and the name used to define said
  attributes in a different section of the Schema.
  """

  @doc"""
  Returns a tuple of response attribute and the name
  to lookup for its type, format, and other meta data
  within the definition section of the resource.
  """
  def map(resource = %Braise.Resource{}) do
    Dict.to_list(resource.response)
    |> flatten_response
  end

  defp flatten_response(tuples, memo \\ [])

  defp flatten_response([], memo), do: memo

  defp flatten_response([{key, value} | tail], memo) do
    new_value = reference_to_definition_key(value)

    flatten_response(tail, memo ++ [{key, new_value}])
  end

  defp reference_to_definition_key(%{"$ref" => value}) do
    regex = ~r/\/definitions\/.*\/definitions\/(?<attribute>.*)/

    Regex.named_captures(regex, value)
    |> Dict.get("attribute")
  end
end
