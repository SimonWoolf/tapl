defmodule Tapl.Chapter4.Evaluator do
  import Tapl.Chapter4.Guards, only: :macros
  import Tapl.Chapter4.Astifier, only: [to_ast: 1, from_ast: 1]

  # Note the second argument to is_numeric_val is the max recursion depth.
  # Can't have arbitrarily recursive macros (inc. guard clauses) as they're
  # expanded out at compile-time
  def eval_term_onestep(term) do
    case term do
      {:if, true, :then, t2, :else, t3} ->
        t2
      {:if, false, :then, t2, :else, t3} ->
        t3
      {:if, t1, :then, t2, :else, t3} ->
        {:if, eval_term_onestep(t1), :then, t2, :else, t3}
      {:succ, t1} ->
        {:succ, eval_term_onestep(t1)}
      {:pred, :'0'} ->
        :'0'
      {:pred, {:succ, nv1}} when is_numeric_val(nv1, 10) ->
        nv1
      {:pred, t1} ->
        {:pred, eval_term_onestep(t1)}
      {:iszero, :'0'} ->
        true
      {:iszero, {:succ, nv1}} when is_numeric_val(nv1, 10) ->
        false
      {:iszero, t1} ->
        {:iszero, eval_term_onestep(t1)}
      other ->
        throw :noruleapplies
    end
  end

  def eval_term(t) do
    result = try do
      eval_term(eval_term_onestep(t))
    catch
      :noruleapplies -> t
    end
  end

  def eval(str) do
    with {:ok, ast} <- to_ast(str) do
      eval_term(ast) |> from_ast
    end
  end
end
