defmodule ResourceAttributeMapTest do
  use ExUnit.Case

  import Braise.ResourceAttributeMap, only: [dereference_response: 2]

  test "deference_response/2 maps the response tuple to the definition section of the JSON" do
    response = [{"guid", "guid"}, {"first_name", "first-name"}]
    definition = %{"guid" => %{ "type" => "string"},
                   "first-name" => %{ "type" => "pirate"}}
    dereferenced_result = %{ "guid" => %{ "type" => "string"},
                             "first_name" => %{ "type" => "pirate"}}

    assert dereferenced_result == dereference_response(response, definition)
  end
end
