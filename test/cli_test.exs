defmodule CLITest do
  use ExUnit.Case

  import Braise.CLI, only: [ parse_options: 1 ]

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
end
