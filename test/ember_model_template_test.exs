defmodule EmberModelTemplateTest do
  use ExUnit.Case

  import Braise.EmberModelTemplate, only: [attribute: 1, attributes: 1, generate: 1]

  test "attribute/1 on a nil type results in an empty Ember DS attr" do
    assert "foo: attr()" == attribute(%{type: nil, name: "foo"})
  end

  test "attribute/1 on a specific type includes it in the DS attr" do
    assert "foo: attr(\"string\")" == attribute(%{type: "string", name: "foo"})
  end

  test "attributes/1 chucks together a merry list of attributes" do
    attributes = [
      %{ type: nil, name: "foo"},
      %{ type: nil, name: "bar"},
      %{ type: nil, name: "baz"}
    ]
    expected_output = "foo: attr(),\n  bar: attr(),\n  baz: attr()"

    assert expected_output == attributes(attributes)
  end

  test "a valid link section produces a good template" do
    expected_template = """
    // DO NOT EDIT - this file was autogenerated by Braise
    import DS from 'ember-data';

    const { Model, attr } = DS;

    export default Model.extend({
      firstName: attr("string"),

      async cancel() {
        const { modelName } = this.constructor;
        const adapter = this.store.adapterFor(modelName);
        const response = await adapter.cancel(modelName, this.get('id'), arguments);
        const serializer = this.store.serializerFor(modelName);
        const payloadKey = serializer.payloadKeyFromModelName(modelName);
        const payload = response[payloadKey];
        this.setProperties(payload);
        return this;
      }
    });
    """

    model = %{
      :name => "person",
      :attributes => [%{:type => "string", :name => "firstName" }],
      :actions => %{
        :unsupported => [ %Braise.LinkAction{name: "delete"} ],
        :non_restful => [ %Braise.LinkAction{name: "cancel"} ]
      }
    }
    actual_template = generate(model)

    assert actual_template == expected_template
  end

end
