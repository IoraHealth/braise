defmodule Braise.CLI do

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
    parse = OptionParser.parse(argv, switches: [help: :boolean, file: :string, output: :string],
                                     aliases:  [h:    :help,    f:     :file,  o:      :output])

    case parse do
      { [help: true], _, _ } -> :help
      { [file: filename, output: output], _, _} -> { :file, filename, :output, output }
      { [file: true], _, _ } -> :missing_file
      { _, _, _} -> :help
    end
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
    {:ok, file} = File.read(filename)

    resource       = Poison.decode!(file, as: Braise.Resource)
    {:ok, name, adapter} = Braise.AdapterTemplate.generate_from_resource(resource)

    adapter_filename = output <> "/addon/adapters/" <> name <> ".js"
    write_to_file(adapter, adapter_filename)

    model_filename = output <> "/addon/models/" <> name <> ".js"

    Braise.Model.parse_from_resource(resource)
    |> Braise.ModelToEmberModel.convert
    |> Braise.EmberModelTemplate.generate
    |> write_to_file(model_filename)
  end

  def write_to_file(content, filename) do
    File.open(filename, [:write], fn(file) ->
      IO.binwrite file, content
    end)
  end
end
