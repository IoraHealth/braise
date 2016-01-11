defmodule ModelTest do
  use ExUnit.Case

  import Braise.Model, only: [parse_from_resource: 1]

  test "parse_from_resource/1 pulls the name from the response" do
    assert "pirate" == parse_from_resource(resource).name
  end

  test "parse_from_resource/1 maps the response tuple to the definition section of the JSON" do
    assert attributes == parse_from_resource(resource).attributes
  end

  def response do
    %{"guid" => %{ "$ref" => "/definitions/pirate/definitions/guid"},
      "first_name" => %{ "name" => "first_name", "type" => ["pirate"], "format" => nil } }
  end

  def definition do
    %{"guid" => %{ "type" => ["string"]}, "first-name" => %{ "type" => ["pirate"]}}
  end

  def resource do
    %Braise.Resource{name: "pirate", definition: definition, response: response}
  end

  def attributes do
    [first_name_attribute, guid_attribute]
  end

  def first_name_attribute do
    %Braise.Attribute{name: "first_name", type: "pirate", format: nil}
  end

  def guid_attribute do
    %Braise.Attribute{name: "guid", type: "string", format: nil}
  end
end
