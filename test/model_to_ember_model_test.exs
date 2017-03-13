defmodule ModelToEmberModelTest do
  use ExUnit.Case

  import Braise.ModelToEmberModel, only: [strip_and_convert_attribute: 1]

  test "strip_and_convert_attribute/1 converts booleans to ember typed booleans" do
    attribute = %{name: "is_admin", type: ["boolean"], format: nil}
    assert %{name: "isAdmin", type: "boolean"} == strip_and_convert_attribute(attribute)
  end

  test "strip_and_convert_attribute/1 handles date-times appropriately" do
    attribute = %{name: "created_at", type: ["string"], format: "date-time"}

    assert %{name: "createdAt", type: "date"} == strip_and_convert_attribute(attribute)
  end

  test "strip_and_convert_attribute/1 handles number conversions as well" do
    integer = %{name: "value", type: ["integer"], format: nil}
    number  = %{name: "amount", type: ["number"], format: nil}

    assert %{name: "value", type: "number"} == strip_and_convert_attribute(integer)
    assert %{name: "amount", type: "number"} == strip_and_convert_attribute(number)
  end

  test "strip_and_convert_attribute/1 strings convert into ember typed strings" do
    string = %{name: "first_name", type: ["string"], format: "uuid"}

    assert %{name: "firstName", type: "string"} == strip_and_convert_attribute(string)
  end

  test "strip_and_convert_attribute/1 converts everything else into a nil type" do
    array = %{name: "practice_user_uids", type: ["array"], format: nil}

    assert %{name: "practiceUserUids", type: nil} == strip_and_convert_attribute(array)
  end

  test "strip_and_convert_attribute/1 handles nullable typed attributes as well" do
    attribute = %{name: "value", type: ["integer", "null"], format: nil}

    assert %{name: "value", type: "number"} == strip_and_convert_attribute(attribute)
  end
end
