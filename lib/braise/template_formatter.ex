defmodule Braise.TemplateFormatter do
  def format_attrs(template_lines) do
    cleanup_template_lines(template_lines)
    |> Enum.join(",\n  ")
  end

  def format_lines(template_lines) do
    cleanup_template_lines(template_lines)
    |> Enum.join(",\n\n  ")
  end

  def format!(template_source) do
    # Strip extraneous whitespace
    Regex.compile!("(^\s+$)|(\s+$|\n{3,})", "m")
    |> Regex.replace(template_source, "")
  end

  defp cleanup_template_lines(template_lines) do
    template_lines
    |> Enum.map(fn m -> String.trim(m) end)
    |> Enum.reject(fn m -> m == nil || m == "" end)
  end
end