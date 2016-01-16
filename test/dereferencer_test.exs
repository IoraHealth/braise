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

  test "dereference/2 pulls patient with recursive definition of guid" do
    patient = %{"name" => "patient", "guid" => %{"type" => ["string"]} }
    assert patient == Enum.at(dereference(response, definition), 2)
  end

  test "dereference/2 pulls links with deep recursive definitions" do
    patient = %{
      "name" => "link",
      "title" => "Create a new patient.",
      "schema" => %{
        "properties" => %{
          "guid" => %{"type" => ["string"]}
        },
        "type" => ["object"]
      }
    }
    assert patient == Enum.at(dereference(%{"link" => link}, definition), 0)
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
      "first_name" => first_name,
      "patient" => %{"guid" => %{ "$ref" => "#/definitions/pirate/definitions/guid"} }
    }
  end

  def link do
    %{
      "title" => "Create a new patient.",
      "schema" => %{
        "properties" => %{
          "guid" => %{
            "$ref" => "#/definitions/patient/definitions/guid"
          }
        },
        "type" => [ "object" ]
      }
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
