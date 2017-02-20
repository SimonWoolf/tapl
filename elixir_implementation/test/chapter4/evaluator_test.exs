defmodule Tapl.Chapter4.EvaluatorTest do
  use ExUnit.Case
  import Tapl.Chapter4.Evaluator, only: [eval: 1]

  test "single value" do
    assert eval('true') == 'true'
  end

  test "single-level if" do
    assert eval('if true then true else true') == 'true'
  end

  test "multi-level if" do
    assert eval('if if true then false else true then if true then true else true else if false then true else false') == 'false'
  end

  test "succ/pred" do
    assert eval('pred succ pred succ pred succ 0') == '0'
  end

  test "non-value normal form" do
    assert eval('if 0 then 0 else 0') == 'if 0 then 0 else 0'
  end

  test "invalid syntax" do
    assert {:error, _} = eval('if iszero succ')
  end
end
