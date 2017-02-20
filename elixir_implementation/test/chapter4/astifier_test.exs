defmodule Tapl.Chapter4.AstifierTest do
  use ExUnit.Case
  import Tapl.Chapter4.Astifier, only: [to_ast: 1]

  test "single-level if" do
    assert to_ast('if true then true else true') == {:ok, {:if, true, :then, true, :else, true}}
  end

  test "multi-level if" do
    assert to_ast('if if 0 then 0 else 0 then if 0 then 0 else 0 else if 0 then 0 else 0') ==
      {:ok, {
        :if,
        {:if, :"0", :then, :"0", :else, :"0"},
        :then,
        {:if, :"0", :then, :"0", :else, :"0"},
        :else,
        {:if, :"0", :then, :"0", :else, :"0"}
      }}
  end

  test "succ/pred" do
    assert to_ast('succ pred succ pred 0') == {:ok, {:succ, {:pred, {:succ, {:pred, :"0"}}}}}
  end
end
