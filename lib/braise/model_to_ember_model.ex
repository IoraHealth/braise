defmodule Braise.ModelToEmberModel do
  def convert(model) do
    %{name: model.name, attributes: convert_attributes(model.attributes), actions: model.actions}
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

  defp convert_attribute(attribute) do
    case attribute do
      %{ type: ["boolean"], format: _, name: name} -> %{ name: camelize(name), type: "boolean" }
      %{ type: ["string"], format: "date-time", name: name} -> %{name: camelize(name), type: "date"}
      %{ type: ["integer"], format: _, name: name} -> %{name: camelize(name), type: "number"}
      %{ type: ["number"], format: _, name: name} -> %{name: camelize(name), type: "number"}
      %{ type: ["string"], format: _, name: name} -> %{ name: camelize(name), type: "string"}
      %{ type: _, format: _, name: name} -> %{ name: camelize(name), type: nil }
    end
  end

  defp camelize(attribute_name) do
    Inflex.camelize(attribute_name, :lower)
  end

  defp strip_null(attribute) do
    new_type = List.delete(attribute.type, "null")
    %Braise.Attribute{name: attribute.name, type: new_type, format: attribute.format}
  end
end
