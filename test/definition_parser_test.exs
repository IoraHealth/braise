defmodule DefinitionParserTest do
  use ExUnit.Case

  import Braise.DefinitionParser, only: [definitions: 1]
  
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

    assert definitions == definitions(resource)
  end
end
