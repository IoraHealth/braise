defmodule Braise.CLI do
  require Braise

  @moduledoc """
  Handles parsing the command line and dispatches to
  the library that pushes out Ember-CLI crud.
  """

  def main(argv) do
    parse_options(argv)
    |> process
    System.halt(0)
  end

  def parse_options(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean, file: :string, output: :string, version: :boolean],
                                     aliases:  [h:    :help,    f:     :file,  o:      :output])

    case parse do
      { [help: true], _, _ } -> :help
      { [version: true], _, _ } -> :version
      { [file: filename, output: output], _, _} -> { :file, filename, :output, output }
      { [file: true], _, _ } -> :missing_file
      { _, _, _} -> :help
    end
  end

  def process(:version) do
    IO.puts """
    Braise version #{Braise.version}
    """
  end

  def process(:help) do
    IO.puts """
    usage: --file <filename> --output <output dir>
    """
  end

  def process(:missing_file) do
    IO.puts "put a file in it dingbat"
    process(:help)
  end

  def process({:file, filename, :output, output}) do
    {:ok, file, version} = read_file(filename)

    Poison.decode!(file, as: Braise.Schema)
    |> Braise.Schema.resources
    |> write_adapters_and_models(version, output)
  end

  def write_adapters_and_models([], _, _), do: true
  def write_adapters_and_models([resource | tail], version, output) do
    {:ok, name, adapter} = Braise.AdapterTemplate.generate_from_resource(resource)

    adapter_filename = output_filename_for(output, "adapters", version, name)
    write_to_file(adapter, adapter_filename)

    model_filename = output_filename_for(output, "model", version, name)

    Braise.Model.parse_from_resource(resource)
    |> Braise.ModelToEmberModel.convert
    |> Braise.EmberModelTemplate.generate
    |> write_to_file(model_filename)

    write_adapters_and_models(tail, version, output)
  end

  def write_to_file(content, filename) do
    File.open(filename, [:write], fn(file) ->
      IO.binwrite file, content
    end)
  end

  def read_file(filename) do
    file = File.read!(filename)
    version = version_from!(filename)

    {:ok, file, version}
  end

  def version_from!(path) do
    captures = Regex.named_captures(~r/\/(?<version>v\d+)\//, path)
    if is_map(captures) do
      Dict.get(captures, "version")
    else
      raise File.Error, reason: "does not follow our version convention", action: "find version from path", path: path
    end
  end

  def output_filename_for(base_dir, type, version, name) do
    name_with_hyphens = String.replace(name, "_", "-")
    dir = Enum.join([base_dir, type, version], "/")
    File.mkdir_p(dir)
    Enum.join([dir, "/", name_with_hyphens, ".js"], "")
  end

end
