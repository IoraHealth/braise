defmodule Braise.ModelToEmberModel do
  def convert(model) do
    %{name: model.name, attributes: convert_attributes(model.attributes)}
  end

  def convert_attributes(model_attributes, converted_attributes \\ []) 
  def convert_attributes([], converted_attributes), do: converted_attributes

  def convert_attributes([head | tail], converted_attributes) do
    convert_attributes(tail, converted_attributes ++ [strip_and_convert_attribute(head)])
  end

  def strip_and_convert_attribute(attribute) do
    strip_null(attribute)
    |> convert_attribute
  end

  def convert_attribute(attribute) do
    case attribute do
      %{ type: ["boolean"], format: _, name: name} -> %{ name: name, type: "boolean" }
      %{ type: ["string"], format: "date-time", name: name} -> %{name: name, type: "date"}
      %{ type: ["integer"], format: _, name: name} -> %{name: name, type: "number"}
      %{ type: ["number"], format: _, name: name} -> %{name: name, type: "number"}
      %{ type: ["string"], format: _, name: name} -> %{ name: name, type: "string"}
      %{ type: _, format: _, name: name} -> %{ name: name, type: nil }
    end
  end

  defp strip_null(attribute) do
    new_type = List.delete(attribute.type, "null")
    %Braise.Attribute{name: attribute.name, type: new_type, format: attribute.format}
  end
end
