defmodule Convabout.Utils do
  def postgrex_result_to_map(postgrex_result) do
    rows = postgrex_result.rows
    columns = postgrex_result.columns |> Enum.map(&String.to_atom(&1))

    Enum.map(rows, fn row ->
      Enum.zip(columns, row) |> Map.new()
    end)
  end
end
