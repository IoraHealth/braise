defmodule AdapterTemplateTest do
  use ExUnit.Case

  import Braise.AdapterTemplate, only: [generate_from_resource: 1, path_for_type: 1]

  # test "an invalid json schema produces an error" do
  #   json = %{"pirate_town" => "YISSSS"}
  #   {:error, msg } = generate_from_resource(json)

  #   assert msg == "Invalid JSON Schema"
  # end

  test "a valid resource with no custom actions produces a good template" do
    resource = %Braise.Resource{
      url: URI.parse("http://production.icisapp.com/api/v2"),
      name: "patients",
      links: []
    }
    expected_template = """
    // DO NOT EDIT - this file was autogenerated by Braise
    import DS from 'ember-data';
    import Ember from 'ember';

    export default DS.RESTAdapter.extend({
      host: "http://production.icisapp.com",
      namespace: "api/v2",
      token: Ember.computed.alias('accessTokenWrapper.token'),
      
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

      
    });
    """
    {:ok, "patients", template } = generate_from_resource(resource)

    assert template == expected_template
  end

  test "a valid resource with a custom action produces a good template" do
    resource = %Braise.Resource{
      url: URI.parse("http://production.icisapp.com/api/v2"),
      name: "patients",
      links: [%Braise.LinkAction{name: "cancel", method: 'PUT'}]
    }
    expected_template = """
    // DO NOT EDIT - this file was autogenerated by Braise
    import DS from 'ember-data';
    import Ember from 'ember';

    export default DS.RESTAdapter.extend({
      host: "http://production.icisapp.com",
      namespace: "api/v2",
      token: Ember.computed.alias('accessTokenWrapper.token'),
      
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

      cancel: function(modelName, id, snapshot) {
        var url = this.buildURL(modelName, id) + '/cancel';
        return this.ajax(url, 'PUT', { data: snapshot });
      }

    });
    """
    {:ok, "patients", template } = generate_from_resource(resource)

    assert template == expected_template
  end

  test "path_for_type does nothing when the resource_name has no underscores" do
    template = path_for_type("patients")

    assert "" == template
  end

  test "path_for_type chucks in the function when the resource name has underscores" do
    expected_template = """
    pathForType: function(type) {
        var underscorized = Ember.String.underscore(type);
        return Ember.String.pluralize(underscorized);
      },
    """

    template = path_for_type("staff_members")

    assert expected_template == template
  end

end
