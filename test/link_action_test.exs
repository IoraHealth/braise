defmodule LinkActionTest do
  use ExUnit.Case

  import Braise.LinkAction, only: [name: 2, non_restful_actions: 1, unsupported_restful_actions: 1]

  test "restful index action" do
    link = %{"method"=>"GET", "href"=>"http://blah.com/api/v1/patients"}
    assert name("patient", link) == %Braise.LinkAction{method: "GET", name: :index, on_member: false, restful: true}
  end

  test "restful show action" do
    link = %{"method"=>"GET", "href"=>"http://blah.com/api/v1/patients/123"}
    assert name("patient", link) == %Braise.LinkAction{method: "GET", name: :show, on_member: true, restful: true}
  end

  test "restful create action" do
    link = %{"method"=>"POST", "href"=>"http://blah.com/api/v1/patients"}
    assert name("patient", link) == %Braise.LinkAction{method: "POST", name: :create, on_member: false, restful: true}
  end

  test "restful update action (put)" do
    link = %{"method"=>"PUT", "href"=>"http://blah.com/api/v1/patients/123"}
    assert name("patient", link) == %Braise.LinkAction{method: "PUT", name: :update, on_member: true, restful: true}
  end

  test "restful update action (patch)" do
    link = %{"method"=>"PATCH", "href"=>"http://blah.com/api/v1/patients/123"}
    assert name("patient", link) == %Braise.LinkAction{method: "PATCH", name: :update, on_member: true, restful: true}
  end

  test "restful delete action" do
    link = %{"method"=>"DELETE", "href"=>"http://blah.com/api/v1/patients/123"}
    assert name("patient", link) == %Braise.LinkAction{method: "DELETE", name: :delete, on_member: true, restful: true}
  end

  test "non-restful cancel action" do
    link = %{"method"=>"PUT", "href"=>"http://blah.com/api/v1/patients/123/cancel"}
    assert name("patient", link) == %Braise.LinkAction{method: "PUT", name: "cancel", on_member: true, restful: false}
  end

  test "finding the non-restful actions" do
    index = %Braise.LinkAction{method: "GET", name: :index, on_member: false, restful: true}
    cancel = %Braise.LinkAction{method: "PUT", name: "cancel", on_member: true, restful: false}
    actions = [index, cancel]
    assert non_restful_actions(actions) == [cancel]
  end

  test "finding the unsupported-restful actions" do
    index = %Braise.LinkAction{method: "GET", name: :index, on_member: false, restful: true}
    cancel = %Braise.LinkAction{method: "PUT", name: "cancel", on_member: true, restful: false}
    actions = [index, cancel]

    expected = [
      %Braise.LinkAction{method: "GET", name: :show, on_member: true, restful: true},
      %Braise.LinkAction{method: "POST", name: :create, on_member: false, restful: true},
      %Braise.LinkAction{method: "PUT", name: :update, on_member: true, restful: true},
      %Braise.LinkAction{method: "PATCH", name: :update, on_member: true, restful: true},
      %Braise.LinkAction{method: "DELETE", name: :delete, on_member: true, restful: true}
    ]
    assert unsupported_restful_actions(actions) == expected
  end

end
