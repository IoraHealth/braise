defmodule Braise.DefinitionParser do
  def definitions(resource = %Braise.Resource{}) do
    {:ok, resource_name} = Braise.Resource.name(resource)

    resource.definitions[resource_name]["definitions"]
  end
end
