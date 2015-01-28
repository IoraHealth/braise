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
    case Braise.Resource.url(resource) do
      {:ok, url}    -> fill_template(url, template_string) |> ok_tuple
      {:error, msg} -> {:error, msg}
    end
  end

  def generate_from_resource(_, _) do
    { :error, "Invalid JSON Schema" }
  end


  defp fill_template(%{host: host, path: path, scheme: scheme}, template_string) do
    String.replace(template_string, ~r/<%= scheme %>/, scheme)
    |> String.replace(~r/<%= host %>/, host)
    |> String.replace(~r/<%= path %>/, path)
    |> String.replace(~r/<%= path_for_type %>/, "")
  end

  defp ok_tuple(string) do
    {:ok, string}
  end
end
