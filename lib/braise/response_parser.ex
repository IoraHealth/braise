defmodule Braise.ResponseParser do
  def response(resource = %Braise.Resource{}) do
    {:ok, resource_name} = Braise.Resource.name(resource)

    Dict.to_list(resource.definitions[resource_name]["properties"])
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
