defmodule ResourceTest do
  use ExUnit.Case

  import Braise.Resource, only: [url: 1, name: 1]

  test "valid resouce results in a parsed URI" do
    uri = "http://crazytown.biz/api/v2"
    resource = %Braise.Resource{links: [%{"href" => uri}]}

    expected_url        = URI.parse(uri)
    {:ok, actual_url}   =  Braise.Resource.url(resource)

    assert expected_url == actual_url
  end

  test "invalid resource results in an error message tuple for URI" do
    resource = %Braise.Resource{links: 'this is the beginning of the song'}

    {:error, msg } = Braise.Resource.url(resource)

    assert msg == "Invalid links portion of JSON Schema"
  end

  test "invalid resource results in an error message tuple for name" do
    resource = %Braise.Resource{definitions: 'rock hard awesome'}

    {:error, msg } = Braise.Resource.name(resource)

    assert msg = "Invalid definition portion of JSON Schema"
  end

  test "valid resource results in a resource name tuple" do
    resource = %Braise.Resource{definitions: %{"patient" => "rock hard awesome"}}

    {:ok, name } = Braise.Resource.name(resource)

    assert name == "patient"
  end
end
