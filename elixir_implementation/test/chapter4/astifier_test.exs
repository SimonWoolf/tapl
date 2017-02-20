defmodule Tapl.Chapter4.AstifierTest do
  use ExUnit.Case
  import Tapl.Chapter4.Astifier

  test "to_ast: single-level if" do
    assert to_ast('if true then true else true') == {:ok, {:if, 'true', :then, 'true', :else, 'true'}}
  end

  test "to_ast: multi-level if" do
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

  test "to_ast: succ/pred" do
    assert to_ast('succ pred succ pred 0') == {:ok, {:succ, {:pred, {:succ, {:pred, :'0'}}}}}
  end

  test "from_ast" do
    assert from_ast({:if, {:succ, :"0"}, :then, 'true', :else, {:iszero, {:pred, :'0'}}}) ==
      'if succ 0 then true else iszero pred 0'
  end
end
