defmodule Braise.AdapterTemplate do

  @moduledoc """
  Constructs a string representation of an Ember-CLI Adapter
  given the passed in JSON Schema Resource.
  """

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
        'AUTHORIZATION': 'Bearer ' + this.get('token')
      };
    }.property('token')
  });
  """

  def generate_from_resource(resource, template_string \\ @template_string)

  @doc """
  Returns a tuple that contains either a string representation of the adapter
  or an error message.

  ## Examples
    iex > resource = %Braise.Resource{definitions: %{"patients" =>{}},
                                      links: [%{"href" => "http://bizdev.biz/api/v1"}]}
    iex > Braise.AdapterTemplate.generate_from_resource(resource)
    {:ok,
     "import DS from 'ember-data';\nimport Ember from 'ember';\n
     \nexport default DS.RESTAdapter.extend({\n  host: \"http://bizdev.biz\",\n
     namespace: \"/api/v1\",\n  token: Ember.computed.alias('accessTokenWrapper.token'),\n  \n\n
     headers: function() {\n    return {\n      'AUTHORIZATION': 'Bearer ' + this.get('token');\n
     };\n  }.property('token')\n});\n"
    }

    iex > Braise.AdapterTemplate.generate_from_resource(%{})
    {:error, "Invalid JSON Schema"}

    iex > Braise.AdapterTemplate.generate_from_resource(%Braise.Resource{definitions: %{"patients" => {}}, links: "Pirate Booty"})
    {:error, "Invalid links portion of JSON Schema"}

    iex > Braise.AdapterTemplate.generate_From_resource(%Braise.Resource{definitions: "Pirate Booty", links: [%{"href" => "http://piratebooty.biz/"}])
    {:error, "Invalid definitions portion of JSON Schema"}


  """
  def generate_from_resource(resource = %Braise.Resource{}, template_string) do
    replace_template_variables(template_string, resource)
    |> ok_tuple(resource.name)
  end

  def generate_from_resource(_, _) do
    { :error, "Invalid JSON Schema" }
  end

  def replace_template_variables(template_string, resource) do
    replace_uri_variables(template_string, resource.url)
    |> replace_path_for_type_variable(resource.name)
  end

  @doc """
  Replaces the scheme, host and path template variables with the representations
  from the Braise.Resource.url

  ## Examples
    iex > template = "<%= scheme %> <%= host %> <%= path %>"
    iex > Braise.AdapterTemplate.replace_uri_variables(template, URI.parse("http://bizdev.com/api"))
    "http bizdev.com /api"
  """
  def replace_uri_variables(template, %{host: host, path: path, scheme: scheme}) do
    String.replace(template, ~r/<%= scheme %>/, scheme)
    |> String.replace(~r/<%= host %>/, host)
    |> String.replace(~r/<%= path %>/, String.slice(path, 1..-1))
  end

  @doc """
  Replaces the path_for_type template variable if it is the passed in resource_name
  is a snake case representation of multiple words. If it is one word, it replaces
  with nothing.

  ## Examples
    iex > template = "<%= path_for_type %>"
    iex > Braise.AdapterTemplate.replace_path_for_type_variable(template, "patient")
    ""
    iex > Braise.AdapterTemplate.replace_path_for_type_variable(template, "staff_members")
    "pathForType: function(type) {\n  var decamelized = Ember.String.decamelize(type);\n  return Ember.String.pluralize(decamelized);\n},\n"
  """

  def replace_path_for_type_variable(template, resource_name) do
    replace_regex = ~r/<%= path_for_type %>/
    function = """
    \n  pathForType: function(type) {
        var decamelized = Ember.String.decamelize(type);
        return Ember.String.pluralize(decamelized);
      },
    """

    replace = case String.match?(resource_name, ~r/_/) do
      true -> function
      _ -> ""
    end

    String.replace(template, replace_regex, replace)
  end

  defp ok_tuple(body, name) do
    {:ok, name, body}
  end
end
