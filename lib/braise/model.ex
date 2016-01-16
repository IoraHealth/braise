defmodule Braise.Model do
  defstruct [:name, :attributes, :actions]
  @moduledoc"""
  Representation of a RESTful resource with a name plus a collection of attributes.
  """

  @doc"""
  Returns a Braise Model with a collection of attributes assigned to the resource
  name.

  ## Examples
      iex > resource = %Braise.Resource{name: "pirate", definition: %{"name" => "booty"}, response: %{"name" => "name"}}
      iex > Braise.Model.parse_from_resource(resource)
      %Braise.Model{name: "pirate", attributes: [%Braise.Attribute{name: "name", type: null, format: null}]}
  """
  def parse_from_resource(resource = %Braise.Resource{}) do
    attributes = Enum.map(resource.response, fn(element)-> map_attribute(element) end)
    actions = %{
      unsupported: Braise.LinkAction.unsupported_restful_actions(resource.links),
      non_restful: Braise.LinkAction.non_restful_actions(resource.links)}
    %Braise.Model{name: resource.name, attributes: attributes, actions: actions, actions: actions}
  end

  defp map_attribute(element) do
    %Braise.Attribute{name: element["name"], type: element["type"], format: element["format"]}
  end
end
