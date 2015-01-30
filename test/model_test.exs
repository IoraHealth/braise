defmodule ResourceAttributeMapTest do
  use ExUnit.Case

  import Braise.Model, only: [dereference_response: 2]

  test "deference_response/2 maps the response tuple to the definition section of the JSON" do
    response   = [{"guid", "guid"}, {"first_name", "first-name"}]
    definition = %{"guid" => %{ "type" => ["string"]},
                   "first-name" => %{ "type" => ["pirate"]}}
   attributes  = [%Braise.Attribute{name: "guid", type: "string", format: nil},
                  %Braise.Attribute{name: "first_name", type: "pirate", format: nil}]

    assert attributes == dereference_response(response, definition)
  end
end
