defmodule Braise.Resource do
  defstruct [:definitions, :links]

  def url(%Braise.Resource{links: [%{"href" => uri}]}) do
    {:ok, URI.parse(uri) }
  end

  def url(_) do
    {:error, "Invalid links portion of JSON Schema"}
  end

  def name(%Braise.Resource{definitions: defs}) when is_map(defs) do
      Dict.keys(defs) 
      |> List.to_string
      |> ok_tuple
  end

  def name(_) do
    {:error, "Invalid definition portion of JSON Schema"}
  end

  defp ok_tuple(resource_name) do
    {:ok, resource_name}
  end
end
