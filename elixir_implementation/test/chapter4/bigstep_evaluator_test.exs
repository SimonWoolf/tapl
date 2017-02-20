defmodule Tapl.Chapter4.BigstepEvaluatorTest do
  use ExUnit.Case
  import Tapl.Chapter4.BigstepEvaluator, only: [eval: 1]

  test "single value" do
    assert eval('true') == 'true'
  end

  test "single-level if" do
    assert eval('if false then true else true') == 'true'
    assert eval('if true then succ 0 else 0') == 'succ 0'
  end

  test "multi-level if" do
    assert eval('if if true then false else true then if true then true else true else if false then true else false') == 'false'
  end

  test "succ/pred" do
    assert eval('pred succ pred succ pred succ 0') == '0'
    assert eval('succ pred succ pred succ 0') == 'succ 0'
  end

  test "non-value normal form" do
    assert eval('if 0 then 0 else 0') == 'if 0 then 0 else 0'
  end

  test "iszero" do
    assert eval('iszero 0') == 'true'
    assert eval('iszero succ 0') == 'false'
  end

  test "invalid syntax" do
    assert {:error, _} = eval('if iszero succ')
  end
end
