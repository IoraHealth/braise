defmodule Braise.AdapterTemplate do
  def generate_from_json(%{"links" => [%{"href" => links}]}) do
    URI.parse(links)
    |> template
  end


  defp template(%{host: host, path: path, scheme: scheme}) do
    """
    import DS from 'ember-data';
    import Ember from 'ember';
    
    export default DS.RESTAdapter.extend({
      host: "#{scheme}://#{host}",
      namespace: "#{path}",
      token: Ember.computed.alias('accessTokenWrapper.token'),

      headers: function() {
        return {
          'AUTHORIZATION': 'Bearer' + this.get('token');
        };
      }.property('token')
    });
    """
  end
end
