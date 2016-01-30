defmodule AcceptanceTest do
  use ExUnit.Case

  import Braise.CLI, only: [process: 1]

  def test_output_dir do
    Path.join [System.cwd(), "test_output"]
  end
  setup do
    File.mkdir test_output_dir

    on_exit fn ->
      File.rm_rf test_output_dir
    end
  end

  test "v3/patients.json" do
    filename = Path.join [System.cwd(), "examples/source/v3/patients.json"]
    process({:file, filename, :output, test_output_dir})

    ["v3/patient.js"]
    |> Enum.each(fn(resource)->
      assert expected_adapter_for(resource) == actual_adapter_for(resource)
      assert expected_model_for(resource) == actual_model_for(resource)
    end)
  end

  test "v3/medication_verification.json" do
    filename = Path.join [System.cwd(), "examples/source/v3/medication_verification.json"]
    process({:file, filename, :output, test_output_dir})

    ["v3/medication-verification.js"]
    |> Enum.each(fn(resource)->
      assert expected_adapter_for(resource) == actual_adapter_for(resource)
      assert expected_model_for(resource) == actual_model_for(resource)
    end)
  end

  test "v20150918/sponsor_api.json" do
    filename = Path.join [System.cwd(), "examples/source/v20150918/sponsor_api.json"]
    process({:file, filename, :output, test_output_dir})

    [
      "v20150918/emergency-contact.js",
      "v20150918/location.js",
      "v20150918/patient.js",
      "v20150918/practice.js",
      "v20150918/staff-member.js",
      "v20150918/state-of-health.js"
    ]
    |> Enum.each(fn(resource)->
      assert expected_adapter_for(resource) == actual_adapter_for(resource)
      assert expected_model_for(resource) == actual_model_for(resource)
    end)
  end

  test "v1/calendar_events.json" do
    filename = Path.join [System.cwd(), "examples/source/v1/calendar_events.json"]
    process({:file, filename, :output, test_output_dir})

    ["v1/calendar-event.js"]
    |> Enum.each(fn(resource)->
      assert expected_adapter_for(resource) == actual_adapter_for(resource)
      assert expected_model_for(resource) == actual_model_for(resource)
    end)
  end

  defp expected_adapter_for(resource) do
    File.read(Path.join [System.cwd(), "examples/output/adapters", resource])
  end

  defp expected_model_for(resource) do
    File.read(Path.join [System.cwd(), "examples/output/model", resource])
  end

  defp actual_adapter_for(resource) do
    File.read(Path.join [test_output_dir, "adapters", resource])
  end

  defp actual_model_for(resource) do
    File.read(Path.join [test_output_dir, "model", resource])
  end
end
