defmodule JsonPointerTest do
  use ExUnit.Case

  import Braise.JsonPointer, only: [lookup: 2]

  test "traversing down to find a definition" do
    actual = lookup("#/definitions/pirate/definitions/guid", simple_definitions)
    assert "a guid is an id" == actual
  end

  test "traversing down and back up with a '#'" do
    actual = lookup("#/definitions/pirate/definitions/location", complex_definitions)
    assert %{ "$ref" => "#/definitions/location/definitions/zip_code"} == actual
  end

  def simple_definitions do
    %{"definitions" =>
      %{"pirate" =>
        %{"definitions" =>
          %{"guid" => "a guid is an id"}
        }
      }
    }
  end

  def complex_definitions do
    %{
      "definitions" => %{
        "pirate" => %{
          "definitions" => %{
            "guid" => "a guid is an id",
            "location" => %{ "$ref" => "#/definitions/location/definitions/zip_code"}
          }
        },
        "location" => %{
          "definitions" => %{
            "zipcode" => "02138"
          }
        }
      }
    }
  end

end
