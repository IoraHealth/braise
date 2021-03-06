defmodule Braise.EmberModelTemplate do
  def generate(model) do
    """
    // DO NOT EDIT - this file was autogenerated by Braise
    import DS from 'ember-data';

    const { Model, attr } = DS;

    export default Model.extend({
      #{model_definition(model)}
    });
    """
    |> Braise.TemplateFormatter.format!
  end

  def model_definition(model) do
    [attributes(model.attributes)] ++ custom_actions(model)
    |> Braise.TemplateFormatter.format_lines
  end

  def attributes(attributes, template \\ [])
  def attributes([], template) do
    Braise.TemplateFormatter.format_attrs(template)
  end

  def attributes([head | tail], template) do
    attributes(tail, template ++ [attribute(head)])
  end

  def attribute(%{type: nil, name: name}), do: "#{name}: attr()"
  def attribute(%{type: type, name: name}), do: "#{name}: attr(\"#{type}\")"

  defp custom_actions(nil), do: ""
  defp custom_actions(model) do
    Enum.map(model.actions.non_restful, &non_restful_javascript/1)
  end

  defp non_restful_javascript(link_action) do
    action_name = link_action.name
    """
      async #{action_name}() {
        const { modelName } = this.constructor;
        const adapter = this.store.adapterFor(modelName);
        const response = await adapter.#{action_name}(modelName, this.get('id'), arguments);
        const serializer = this.store.serializerFor(modelName);
        const payloadKey = serializer.payloadKeyFromModelName(modelName);
        const payload = response[payloadKey];
        this.setProperties(payload);
        return this;
      }
    """
  end
end
