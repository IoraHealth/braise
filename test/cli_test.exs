defmodule CLITest do
  use ExUnit.Case

  import Braise.CLI, only: [
    parse_options: 1, read_file: 1, version_from!: 1, output_filename_for: 4
  ]

  test "passing --help or -h into parse_options returns :help" do
    assert parse_options(["-h", "science"]) == :help
    assert parse_options(["--help", "magic"]) == :help
  end

  test "passing a file without a file on the file flag returns :help" do
    assert parse_options(["-f"]) == :help
    assert parse_options(["--file"]) == :help
  end

  test "passing a file without an output dir returns :help" do
    assert parse_options(["-f", "pirate_town.jpg"]) == :help
    assert parse_options(["--file", "pirate_town.jpg"]) == :help
  end

  test "passing an output dir without a file returns :help" do
    assert parse_options(["-o", "somewhere/to/save"]) == :help
    assert parse_options(["--output", "somewhere/to/save"]) == :help
  end

  test "passing a file with a filename returns a tuple containing the filename" do
    assert parse_options(["-f", "pirate_town.jpg", "-o", "somewhere/to/save"]) == { :file, "pirate_town.jpg", :output, "somewhere/to/save" }
    assert parse_options(["--file", "pirate_village.jpg", "--output", "somewhere/to/save"]) == { :file, "pirate_village.jpg", :output, "somewhere/to/save" }
  end

  test "passing an empty list into parse_options returns :help" do
    assert parse_options([]) == :help
  end

  test "path not following our version convention raises error" do
    assert_raise File.Error, "could not read file bad/path/that/does/not/exist.json: no such file or directory", fn ->
      read_file("bad/path/that/does/not/exist.json")
    end
  end

  test "path that doesn't match our versioning pattern raises an error" do
    assert_raise File.Error, "could not find version from path path/withoiut/version/resource.json: unknown POSIX error", fn ->
      version_from!("path/withoiut/version/resource.json")
    end
  end

  test "version can be extracted from path" do
    assert version_from!("path/to/v123/resource.json") == "v123"
  end

  test "builds a proper output file path" do
    assert output_filename_for("/tmp/addon", "model", "v123", "concise_patient") == "/tmp/addon/model/v123/concise-patient.js"
  end
end
