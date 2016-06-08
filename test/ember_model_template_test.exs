defmodule EmberModelTemplateTest do
  use ExUnit.Case

  import Braise.EmberModelTemplate, only: [attribute: 1, attributes: 1, generate: 1]

  test "attribute/1 on a nil type results in an empty Ember DS attr" do
    assert "foo: DS.attr()," == attribute(%{type: nil, name: "foo"})
  end

  test "attribute/1 on a specific type includes it in the DS attr" do
    assert "foo: DS.attr(\"string\")," == attribute(%{type: "string", name: "foo"})
  end

  test "attributes/1 chucks together a merry list of attributes" do
    attributes = [
      %{ type: nil, name: "foo"},
      %{ type: nil, name: "bar"},
      %{ type: nil, name: "baz"}
    ]
    expected_output = "foo: DS.attr(),\n  bar: DS.attr(),\n  baz: DS.attr(),"

    assert expected_output == attributes(attributes)
  end

  test "a valid link section produces a good template" do
    expected_template = """
    // DO NOT EDIT - this file was autogenerated by Braise
    import DS from 'ember-data';

    export default DS.Model.extend({
      first_name: DS.attr("string"),

      delete: function() {
        throw new Error("'delete' is not supported by the api");
      },

      cancel: function() {
        var _this = this;
        var modelName = this.constructor.modelName;
        var adapter = this.store.adapterFor(modelName);
        return adapter.cancel(modelName, this.get('id'), arguments).then(function(response) {
          var serializer = _this.store.serializerFor(modelName);
          var payloadKey = serializer.payloadKeyFromModelName(modelName);
          var payload = response[payloadKey];
          _this.setProperties(payload);
        });
      },

    });
    """

    model = %{
      :name => "person",
      :attributes => [%{:type => "string", :name => "first_name" }],
      :actions => %{
        :unsupported => [ %Braise.LinkAction{name: "delete"} ],
        :non_restful => [ %Braise.LinkAction{name: "cancel"} ]
      }
    }
    actual_template = generate(model)

    assert actual_template == expected_template
  end

end
