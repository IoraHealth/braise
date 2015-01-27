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
    parse = OptionParser.parse(argv, switches: [help: :boolean, file: :boolean], 
                                     aliases:  [h:    :help,    f:     :file])

    case parse do
      { [help: true], _, _ } -> :help
      { [file: true], [filename], _} -> { :file, filename }
      { [file: true], _, _ } -> :missing_file
      { _, _, _} -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: --file <filename>
    """
  end

  def process(:missing_file) do
    IO.puts "put a file in it dingbat"
    process(:help)
  end

  def process({:file, filename}) do
    {:ok, file} = File.read(filename)

    json = Poison.Parser.parse!(file)
    {:ok, adapter} = Braise.AdapterTemplate.generate_from_json(json)
    IO.puts adapter

    serializer_template = Braise.SerializerTemplate.generate_from_json(json)
    serializer_output = case serializer_template do
      {:ok, serializer } -> serializer
      {:noop, _ } -> "No Serializer needed"
    end

    IO.puts serializer_output
  end
end
