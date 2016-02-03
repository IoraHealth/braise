defmodule Braise.LinkAction do

  @moduledoc """
  The representation of an action supported by the api.
  """
  defstruct [:restful, :name, :method, :on_member]

  def name(resource, link) do
    %{"id"=>id, "custom_action"=>custom_action} = parse_resource_url(resource, link["href"])
    if custom_action == "" do
      restful_action(link["method"], id)
    else
      non_resful_action(link["method"], id, custom_action)
    end
  end

  def non_restful_actions(link_actions) do
    {_, non_restful_actions} = partition_by_restfulness(link_actions)
    non_restful_actions
  end

  def unsupported_restful_actions(link_actions) do
    {restful_actions, _} = partition_by_restfulness(link_actions)
    all_restful_actions = [
      %Braise.LinkAction{restful: true, name: :index, method: "GET", on_member: false},
      %Braise.LinkAction{restful: true, name: :show, method: "GET", on_member: true},
      %Braise.LinkAction{restful: true, name: :create, method: "POST", on_member: false},
      %Braise.LinkAction{restful: true, name: :update, method: "PUT", on_member: true},
      %Braise.LinkAction{restful: true, name: :delete, method: "DELETE", on_member: true}
    ]

    all_restful_actions -- restful_actions
  end

  defp partition_by_restfulness(link_actions) do
    Enum.partition(link_actions, fn(link_action)-> link_action.restful end)
  end

  defp restful_action("GET", "") do
    %Braise.LinkAction{restful: true, name: :index, method: "GET", on_member: false}
  end
  defp restful_action("GET", _) do
    %Braise.LinkAction{restful: true, name: :show, method: "GET", on_member: true}
  end
  defp restful_action("POST", "") do
    %Braise.LinkAction{restful: true, name: :create, method: "POST", on_member: false}
  end
  defp restful_action("PUT", _) do
    %Braise.LinkAction{restful: true, name: :update, method: "PUT", on_member: true}
  end
  defp restful_action("PATCH", _) do
    %Braise.LinkAction{restful: true, name: :update, method: "PUT", on_member: true}
  end
  defp restful_action("DELETE", _) do
    %Braise.LinkAction{restful: true, name: :delete, method: "DELETE", on_member: true}
  end

  defp non_resful_action(method, "", custom_action) do
    %Braise.LinkAction{restful: false, name: custom_action, method: method, on_member: false}
  end

  defp non_resful_action(method, _, custom_action) do
    %Braise.LinkAction{restful: false, name: custom_action, method: method, on_member: true}
  end

  # TODO: The dereferencer should do this lookup for us - but and better than this by using the definitions
  # For now this is good enough for our samples
  defp parse_resource_url(resource, href) do
    plural_resource = "#{resource}s"

    href = String.replace(href, "{(%2Fschemata%2F#{resource}%23%2Fdefinitions%2Fidentity)}", "id")
    |> String.replace("{(%23%2Fdefinitions%2F#{resource}%2Fdefinitions%2Fidentity)}", "id")

    captures = ~r/.*#{plural_resource}\/?(?<id>\w*)\/?(?<custom_action>.*)/
    |> Regex.named_captures(href)
    case captures do
       nil -> %{"id"=>"", "custom_action"=>""}
       _ -> captures
    end
  end

end
