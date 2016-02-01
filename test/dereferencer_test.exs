defmodule DereferencerTest do
  use ExUnit.Case

  import Braise.Dereferencer, only: [dereference: 2]

  test "dereference/2 pulls the inline first_name" do
    assert first_name == dereference(response, schema)["first_name"]
  end

  test "dereference/2 pulls the guid from the definitions" do
    assert guid == dereference(response, schema)["guid"]
  end

  def first_name do
    %{ "name" => "first_name", "type" => ["pirate"], "format" => nil }
  end

  def guid do
    %{ "type" => ["string"]}
  end

  def response do
    %{
      "guid" => %{ "$ref" => "/definitions/pirate/definitions/guid"},
      "first_name" => first_name
    }
  end

  def schema do
    %{"definitions" =>
      %{"pirate" =>
        %{"definitions" =>
          %{"guid" => guid}}}}
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
