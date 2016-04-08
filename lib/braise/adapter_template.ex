defmodule Braise.AdapterTemplate do

  @moduledoc """
  Constructs a string representation of an Ember-CLI Adapter
  given the passed in JSON Schema Resource.
  """

  # @doc """
  # Returns a tuple that contains a string representation of the adapter
  # ## Examples

  #     iex > resource = %Braise.Resource{definitions: %{"patients" =>{}},
  #                                       links: [%{"href" => "http://bizdev.biz/api/v1"}]}
  #     iex > Braise.AdapterTemplate.generate_from_resource(resource)
  #     {:ok,
  #      "import DS from 'ember-data';\nimport Ember from 'ember';\n
  #      \nexport default DS.RESTAdapter.extend({\n  host: \"http://bizdev.biz\",\n
  #      namespace: \"/api/v1\",\n  token: Ember.computed.alias('accessTokenWrapper.token'),\n  \n\n
  #      headers: function() {\n    return {\n      'AUTHORIZATION': 'Bearer ' + this.get('token');\n
  #      };\n  }.property('token')\n});\n"
  #     }
  # """
  def generate_from_resource(resource) do
    """
    // DO NOT EDIT - this file was autogenerated by Braise
    import DS from 'ember-data';
    import Ember from 'ember';

    export default DS.RESTAdapter.extend({
      host: "#{resource.url.scheme}://#{resource.url.host}",
      namespace: "#{path_without_leading_slash(resource)}",
      token: Ember.computed.alias('accessTokenWrapper.token'),
      #{path_for_type(resource.name)}
      #{authorization}
      #{custom_actions(resource)}
    });
    """
    |> ok_tuple(resource.name)
  end

  defp path_without_leading_slash(resource) do
    String.slice(resource.url.path, 1..-1)
  end

  @doc """
  Returns javascript string for pathForType property if it is the passed in resource_name
  is a snake case representation of multiple words. If it is one word, it replaces
  with nothing.

  ## Examples
    iex > template = "<%= path_for_type %>"
    iex > Braise.AdapterTemplate.path_for_type("patient")
    ""
    iex > Braise.AdapterTemplate.path_for_type("staff_members")
    "pathForType: function(type) {\n  var underscorized = Ember.String.underscore(type);\n  return Ember.String.pluralize(underscorized);\n},\n"
  """
  def path_for_type(resource_name) do
    if String.match?(resource_name, ~r/_/) do
      """
      pathForType: function(type) {
          var underscorized = Ember.String.underscore(type);
          return Ember.String.pluralize(underscorized);
        },
      """
    else
      ""
    end
  end

  defp authorization do
    """
    ajaxOptions: function(url, type, options) {
        options = options || {};
        if (type === "GET") {
          options.data = options.data || {};
          options.data["access_token"] = this.get('token');
        } else {
          options.headers = options.headers || {};
          options.headers["Authorization"] = 'Bearer ' + this.get('token');
        }
        return this._super(url, type, options);
      },
    """
  end

  defp custom_actions(resource) do
    Braise.LinkAction.non_restful_actions(resource.links)
    |> Enum.map(&non_restful_javascript/1)
    |> Enum.join(",\n")
  end

  defp non_restful_javascript(link_action) do
    action_name = link_action.name
    method = link_action.method
    """
    #{action_name}: function(modelName, id, snapshot) {
        var url = this.buildURL(modelName, id) + '/#{action_name}';
        return this.ajax(url, '#{method}', { data: snapshot });
      }
    """
  end

  defp ok_tuple(body, name) do
    {:ok, name, body}
  end
end
