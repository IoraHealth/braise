defmodule Braise.SerializerTemplate do
  def generate_from_json(%{"properties" => value}) do
    Dict.keys(value)
    |> List.to_string
    |> template 
  end

  defp template(resource) do
    cond do
      Regex.match?(~r/_/, resource) -> {:ok, resource}
      true -> {:noop, ""}
    end
  end
end
