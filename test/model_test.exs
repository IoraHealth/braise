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
    [%{"name" => "guid",  "type" => ["string"]},
     %{"name" => "first_name", "type" => ["pirate"], "format" => nil }]
  end

  def resource do
    %Braise.Resource{name: "pirate", response: response, links: []}
  end

  def attributes do
    [guid_attribute, first_name_attribute]
  end

  def first_name_attribute do
    %Braise.Attribute{name: "first_name", type: ["pirate"], format: nil}
  end

  def guid_attribute do
    %Braise.Attribute{name: "guid", type: ["string"], format: nil}
  end
end
