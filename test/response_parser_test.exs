defmodule ResponseParserTest do
  use ExUnit.Case

  import Braise.ResponseParser, only: [response: 1]

  test "response/1 returns a tuple of response attr and definition key" do
    response = %{"dob" =>        %{"$ref" => "#/definitions/patient/definitions/dob"},
                 "email" =>      %{"$ref" => "#/definitions/patient/definitions/email"},
                 "first_name" => %{"$ref" => "#/definitions/patient/definitions/first_name"},
                 "guid" =>       %{"$ref" => "#/definitions/patient/definitions/pirate"}}

    expected_result = [{"dob", "dob"}, {"email", "email"}, {"first_name", "first_name"}, {"guid", "pirate"}]

    resource = %Braise.Resource{definitions: %{"patient" => %{"properties" => response}}}

    assert expected_result == response(resource)
  end

end
