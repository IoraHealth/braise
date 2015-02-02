defmodule ModelToEmberModelTest do
  use ExUnit.Case

  import Braise.ModelToEmberModel, only: [convert_attribute: 1, convert_attributes: 1]

  test "convert_attribute/1 converts booleans to ember typed booleans" do
    attribute = %{name: "is_admin", type: "boolean", format: nil}
    assert %{name: "is_admin", type: "boolean"} == convert_attribute(attribute)
  end

  test "convert_attribute/1 handles date-times appropriately" do
    attribute = %{name: "created_at", type: "string", format: "date-time"}

    assert %{name: "created_at", type: "date"} == convert_attribute(attribute)
  end

  test "convert_attribute/1 handles number conversions as well" do
    integer = %{name: "value", type: "integer", format: nil}
    number  = %{name: "amount", type: "number", format: nil}

    assert %{name: "value", type: "number"} == convert_attribute(integer)
    assert %{name: "amount", type: "number"} == convert_attribute(number)
  end

  test "convert_attribute/1 strings convert into ember typed strings" do
    string = %{name: "first_name", type: "string", format: "uuid"}

    assert %{name: "first_name", type: "string"} == convert_attribute(string)
  end

  test "convert_attribute/1 converts everything else into a nil type" do
    array = %{name: "practice_user_uids", type: "array", format: nil}

    assert %{name: "practice_user_uids", type: nil} == convert_attribute(array)
  end
end
