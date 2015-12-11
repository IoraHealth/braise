defmodule AdapterTemplateTest do
  use ExUnit.Case

  import Braise.AdapterTemplate, only: [generate_from_resource: 1, generate_from_resource: 2, replace_path_for_type_variable: 2]

  test "an invalid json schema produces an error" do
    json = %{"pirate_town" => "YISSSS"}
    {:error, msg } = generate_from_resource(json)

    assert msg == "Invalid JSON Schema"
  end

  test "a valid link section produces a good template" do
    resource = %Braise.Resource{url: URI.parse("http://production.icisapp.com/api/v2"), name: "patients"}
    expected_template = """
    import DS from 'ember-data';
    import Ember from 'ember';

    export default DS.RESTAdapter.extend({
      host: "http://production.icisapp.com",
      namespace: "api/v2",
      token: Ember.computed.alias('accessTokenWrapper.token'),
      
      headers: function() {
        return {
          'AUTHORIZATION': 'Bearer ' + this.get('token')
        };
      }.property('token')
    });
    """
    {:ok, "patients", template } = generate_from_resource(resource)

    assert template == expected_template
  end

  test "path_for_type does nothing when the resource_name has no underscores" do
    template = replace_path_for_type_variable("<%= path_for_type %>", "patients")

    assert "" == template
  end

  test "path_for_type chucks in the function when the resource name has underscores" do
    simple_template = "<%= path_for_type %>"
    expected_template = """
    \n  pathForType: function(type) {
        var decamelized = Ember.String.decamelize(type);
        return Ember.String.pluralize(decamelized);
      },
    """

    template = replace_path_for_type_variable(simple_template, "staff_members")

    assert expected_template == template
  end

end
