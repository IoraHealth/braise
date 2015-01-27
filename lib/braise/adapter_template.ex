defmodule Braise.AdapterTemplate do
  def generate_from_json(%{"links" => [%{"href" => links}]}) do
    href = URI.parse(links)
    |> template
  end

  def generate_from_json(_) do
    { :error, "Invalid JSON Schema" }
  end


  defp template(%{host: host, path: path, scheme: scheme}) do
    file_string = """
    import DS from 'ember-data';
    import Ember from 'ember';
    
    export default DS.RESTAdapter.extend({
      host: "#{scheme}://#{host}",
      namespace: "#{path}",
      token: Ember.computed.alias('accessTokenWrapper.token'),

      headers: function() {
        return {
          'AUTHORIZATION': 'Bearer ' + this.get('token');
        };
      }.property('token')
    });
    """

    { :ok, file_string }
  end
end
