defmodule SchemaTest do
  use ExUnit.Case

  import Braise.Schema, only: [url: 1, resources: 1]

  test "url/1 valid schema results in a parsed URI" do
    uri = "http://crazytown.biz/api/v2"
    resource = %Braise.Schema{links: [%{"href" => uri}]}

    expected_url        = URI.parse(uri)
    {:ok, actual_url}   =  url(resource.links)

    assert expected_url == actual_url
  end

  test "url/1 invalid resource results in an error message tuple for URI" do
    resource = %Braise.Schema{links: 'this is the beginning of the song'}

    {:error, msg } = url(resource.links)

    assert msg == "Invalid links portion of JSON Schema"
  end

  test "resources/1 returns a length of the resources provided in the definition" do
    assert Enum.count(resources) == 1
  end

  test "resources/1 sets the resource name" do
    assert resource.name == "patient"
  end

  test "resource/1 sets the response to definition reference names" do
    assert resource.response == [
      %{"dob" => definition_meat["dob"]},
      %{"email" => definition_meat["email"]},
      %{"guid" => definition_meat["guid"]},
      %{"title" => definition_properties["title"]}
    ]
  end

  def resources, do: Braise.Schema.resources(schema)

  def resource, do: List.first(resources)

  def schema do
    %Braise.Schema{definitions: definitions, properties: properties ,links: [%{"href" => "http://bizdev.lol"}]}
  end

  def definitions do
    %{"patient" =>
      %{"definitions" => definition_meat,
        "properties" => definition_properties
       }
     }
  end

  def definition_meat do
    %{"dob" => %{"description" => "The patients date of birth", "example" => "2012-01-01T12:00:00Z", "format" => "date-time",
                "type" => ["string"]},
      "email" => %{"description" => "The patients email", "example" => "gorby.puff.puff.thunderhorse@gmail.com",
                   "type" => ["string"]},
      "guid" => %{"description" => "unique identifier of patient", "example" => "adsgjh2352462cah23jh23asd4avb", "format" => "uuid",
                  "type" => ["string"]},
      "identity" => %{"$ref" => "#/definitions/patient/definitions/guid"}
     }
  end

  def definition_properties do
    %{"dob" => %{"$ref" => "#/definitions/patient/definitions/dob"},
      "email" => %{"$ref" => "#/definitions/patient/definitions/email"},
      "guid" => %{"$ref" => "#/definitions/patient/definitions/guid"},
      "title" => %{"description" => "Patient Resource", "type" => ["object"]}
     }
  end

  def  properties do
    %{"patient" => %{"$ref" => "#/definitions/patient"}}
  end
end
