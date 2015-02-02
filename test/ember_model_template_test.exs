defmodule EmberModelTemplateTest do
  use ExUnit.Case

  import Braise.EmberModelTemplate, only: [attribute: 1, attributes: 1]

  test "attribute/1 on a nil type results in an empty Ember DS attr" do
    assert "foo: DS.attr()" == attribute(%{type: nil, name: "foo"})
  end

  test "attribute/1 on a specific type includes it in the DS attr" do
    assert "foo: DS.attr(\"string\")" == attribute(%{type: "string", name: "foo"})
  end

  test "attributes/1 chucks together a merry list of attributes" do
    attributes = [
      %{ type: nil, name: "foo"},
      %{ type: nil, name: "bar"},
      %{ type: nil, name: "baz"}
    ]
    expected_output = "foo: DS.attr(),\n  bar: DS.attr(),\n  baz: DS.attr()"

    assert expected_output == attributes(attributes)
  end
end
