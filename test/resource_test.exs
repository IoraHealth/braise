defmodule ResourceTest do
  use ExUnit.Case

  import Braise.Resource, only: [url: 1, name: 1]

  test "valid resouce results in a parsed URI" do
    uri = "http://crazytown.biz/api/v2"
    resource = %Braise.Resource{links: [%{"href" => uri}]}

    expected_url        = URI.parse(uri)
    {:ok, actual_url}   =  url(resource)

    assert expected_url == actual_url
  end

  test "invalid resource results in an error message tuple for URI" do
    resource = %Braise.Resource{links: 'this is the beginning of the song'}

    {:error, msg } = url(resource)

    assert msg == "Invalid links portion of JSON Schema"
  end

  test "invalid resource results in an error message tuple for name" do
    resource = %Braise.Resource{definitions: 'rock hard awesome'}

    {:error, msg } = name(resource)

    assert msg == "Invalid definition portion of JSON Schema"
  end

  test "valid resource results in a resource name tuple" do
    resource = %Braise.Resource{definitions: %{"patient" => "rock hard awesome"}}

    {:ok, name } = name(resource)

    assert name == "patient"
  end

  test "definitions/1 pulls the attribute definitions out of the resource" do
    definitions = %{"dob" =>        %{"description" => "The patients date of birth",
                                      "example" => "2012-01-01T12:00:00Z", 
                                      "format" => "date-time",
                                      "type" => ["string"]},
                    "email" =>      %{"description" => "The patients email",
                                      "example" => "gorby.puff.puff.thunderhorse@gmail.com",
                                      "type" => ["string"]},
                    "first_name" => %{"description" => "The first name of the patient",
                                      "example" => "Gorby", 
                                      "type" => ["string"]},
                    "guid" =>       %{"description" => "unique identifier of patient",
                                      "example" => "adsgjh2352462cah23jh23asd4avb", 
                                      "format" => "uuid",
                                      "type" => ["string"]}}
    resource = %Braise.Resource{definitions: %{"patient" => %{"definitions" => definitions}}}

    assert definitions == Braise.Resource.definitions(resource)
  end

  test "response/1 pulls the response with attribute references out of the resouce" do
    response = %{"dob" =>        %{"$ref" => "#/definitions/patient/definitions/dob"},
                 "email" =>      %{"$ref" => "#/definitions/patient/definitions/email"},
                 "first_name" => %{"$ref" => "#/definitions/patient/definitions/first_name"},
                 "guid" =>       %{"$ref" => "#/definitions/patient/definitions/guid"}}

    resource = %Braise.Resource{definitions: %{"patient" => %{"properties" => response}}}

    assert response == Braise.Resource.response(resource)
  end
end
