defmodule Braise.EmberModelTemplate do
  def generate(model) do
    """
    // DO NOT EDIT - this file was autogenerated by Braise
    import DS from 'ember-data';

    export default DS.Model.extend({
      #{attributes(model.attributes)}
    });
    """
  end

  def attributes(attributes, template \\ [])

  def attributes([], template) do
    Enum.join(template, ",\n  ")
  end

  def attributes([head | tail], template) do
    attributes(tail, template ++ [attribute(head)])
  end

  def attribute(%{type: nil, name: name}), do: "#{name}: DS.attr()"
  def attribute(%{type: type, name: name}), do: "#{name}: DS.attr(\"#{type}\")"
end
