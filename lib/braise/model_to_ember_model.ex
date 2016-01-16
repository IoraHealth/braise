defmodule Braise.ModelToEmberModel do
  def convert(model) do
    %{name: model.name, attributes: convert_attributes(model.attributes), actions: model.actions}
  end

  def convert_attributes(model_attributes, converted_attributes \\ [])

  def convert_attributes([], converted_attributes), do: converted_attributes

  def convert_attributes([head | tail], converted_attributes) do
    convert_attributes(tail, converted_attributes ++ [convert_attribute(head)])
  end

  def convert_attribute(attribute) do
    case attribute do
      %{ type: "boolean", format: _, name: name} -> %{ name: name, type: "boolean" }
      %{ type: "string", format: "date-time", name: name} -> %{name: name, type: "date"}
      %{ type: "integer", format: _, name: name} -> %{name: name, type: "number"}
      %{ type: "number", format: _, name: name} -> %{name: name, type: "number"}
      %{ type: "string", format: _, name: name} -> %{ name: name, type: "string"}
      %{ type: _, format: _, name: name} -> %{ name: name, type: nil }
    end
  end
end
