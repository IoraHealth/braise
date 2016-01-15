defmodule DereferencerTest do
  use ExUnit.Case

  import Braise.Dereferencer, only: [dereference: 2]

  test "dereference/2 pulls the inline first_name" do
    assert first_name == Enum.at(dereference(response, definition), 0)
  end

  test "dereference/2 pulls the guid from the definitions" do
    guid_with_name = %{ "name" => "guid", "type" => ["string"]}
    assert guid_with_name == Enum.at(dereference(response, definition), 1)
  end

  # test "dereference/2 pulls definitions recursively" do
  #   guid_with_name = %{ "name" => "guid", "type" => ["string"]}
  #   assert guid_with_name == Enum.at(dereference(response, definition), 2)
  # end

  def first_name do
    %{ "name" => "first_name", "type" => ["pirate"], "format" => nil }
  end

  def guid do
    %{ "type" => ["string"]}
  end

  def response do
    %{"guid" => %{ "$ref" => "/definitions/pirate/definitions/guid"},
      "first_name" => first_name
    }
  end

  def definition do
    %{"guid" => guid}
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
