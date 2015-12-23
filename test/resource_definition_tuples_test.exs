defmodule ResourceDefinitionTuplesTest do
  use ExUnit.Case

  import Braise.ResourceDefinitionTuples, only: [map: 1]

  test "response/1 returns a tuple of response attr and definition key" do
    response = %{"dob" =>        %{"$ref" => "#/definitions/patient/definitions/dob"},
                 "email" =>      %{"$ref" => "#/definitions/patient/definitions/email"},
                 "first_name" => %{"$ref" => "#/definitions/patient/definitions/first_name"},
                 "guid" =>       %{"$ref" => "#/definitions/patient/definitions/pirate"}}

    list_of_references = Dict.to_list(response)
    expected_result = [{"dob", "dob"}, {"email", "email"}, {"first_name", "first_name"}, {"guid", "pirate"}]

    assert expected_result == map(list_of_references)
  end

end
