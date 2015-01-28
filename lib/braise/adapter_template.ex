defmodule Braise.AdapterTemplate do
  @template_string """
  import DS from 'ember-data';
  import Ember from 'ember';

  export default DS.RESTAdapter.extend({
    host: "<%= scheme %>://<%= host %>",
    namespace: "<%= path %>",
    token: Ember.computed.alias('accessTokenWrapper.token'),
    <%= path_for_type %>

    headers: function() {
      return {
        'AUTHORIZATION': 'Bearer ' + this.get('token');
      };
    }.property('token')
  });
  """

  def generate_from_resource(resource, template_string \\ @template_string)

  def generate_from_resource(resource = %Braise.Resource{}, template_string) do
    resource_tuples = [Braise.Resource.url(resource), Braise.Resource.name(resource)]

    case resource_tuples do
       [{:ok, url}, {:ok, name}] -> fill_template(template_string, url, name) |> ok_tuple
       [{:error, msg}, {:ok, _}] -> {:error, msg}
       [{:ok, _}, {:error, msg}] -> {:error, msg}
       _ -> generate_from_resource(nil, nil)
    end
  end

  def generate_from_resource(_, _) do
    { :error, "Invalid JSON Schema" }
  end

  defp fill_template(template_string, uri, resource_name) do
    replace_uri_variables(template_string, uri)
    |> replace_path_for_type_variable(resource_name)
  end

  defp replace_uri_variables(template, %{host: host, path: path, scheme: scheme}) do
    String.replace(template, ~r/<%= scheme %>/, scheme)
    |> String.replace(~r/<%= host %>/, host)
    |> String.replace(~r/<%= path %>/, path)
  end

  defp replace_path_for_type_variable(template, resource_name) do
    replace_regex = ~r/<%= path_for_type %>/
    function = """
    pathForType: function(type) {
      var decamelized = Ember.String.decamelize(type);
      return Ember.String.pluralize(decamelized);
    },
    """

    if String.match?(resource_name, ~r/_/) do
      String.replace(template, replace_regex, function)
    else
      String.replace(template, replace_regex, "")
    end
  end

  defp ok_tuple(string) do
    {:ok, string}
  end
end
