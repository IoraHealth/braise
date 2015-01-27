defmodule CLITest do
  use ExUnit.Case

  import Braise.CLI, only: [ parse_options: 1 ]

  test "passing --help or -h into parse_options returns :help" do
    assert parse_options(["-h", "science"]) == :help
    assert parse_options(["--help", "magic"]) == :help
  end

  test "passing a file without a filename returns :missing_file" do
    assert parse_options(["-f"]) == :missing_file
    assert parse_options(["--file"]) == :missing_file
  end

  test "passing a file with a filename returns a tuple containing the filename" do
    assert parse_options(["-f", "pirate_town.jpg"]) == { :file, "pirate_town.jpg" }
    assert parse_options(["--file", "pirate_village.jpg"]) == { :file, "pirate_village.jpg" }
  end

  test "passing an empty list into parse_options returns :help" do
    assert parse_options([]) == :help
  end
end
