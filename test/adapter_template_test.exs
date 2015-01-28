defmodule AdapterTemplateTest do
  use ExUnit.Case

  import Braise.AdapterTemplate

  test "a valid link section produces a good template" do
    resource = %Braise.Resource{links: [%{"href" => "http://production.icisapp.com/api/v2"}]}
    expected_template = """
    import DS from 'ember-data';
    import Ember from 'ember';
    
    export default DS.RESTAdapter.extend({
      host: "http://production.icisapp.com",
      namespace: "/api/v2",
      token: Ember.computed.alias('accessTokenWrapper.token'),

      headers: function() {
        return {
          'AUTHORIZATION': 'Bearer ' + this.get('token');
        };
      }.property('token')
    });
    """
    {:ok, template } = generate_from_resource(resource)

    assert template == expected_template
  end

  test "an invalid json schema produces an error" do
    json = %{"pirate_town" => "YISSSS"}

    {:error, msg } = generate_from_resource(json)

    assert msg == "Invalid JSON Schema"
  end
end
