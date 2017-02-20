defmodule Tapl.Chapter4.BigstepEvaluator do
  import Tapl.Chapter4.Guards, only: :macros
  import Tapl.Chapter4.Astifier, only: [to_ast: 1, from_ast: 1]

  def is_v(t) do
    case t do
      'true'        -> true
      'false'       -> true
      other         -> is_nv(other)
    end
  end

  def is_nv(t) do
    case t do
      :"0"          -> true
      {:succ, term} -> is_nv(term)
      _             -> false
    end
  end

  # Macro bullshit \o/
  # Each rule is:
  # {match_clause, condition}
  # where a rule is used if both the match clause matches and the condition
  # (which may use variables defined in the match) succeeds.  The condition
  # also evaluates to the final value.
  # This approach gets around the elixir lack of recursive functions in guard clauses
  def eval_term(term) do
    bigstep_rule(term, [
      # B-Value
      {_, is_v(term) && term},
      # B-IfTrue
      {{:if, t1, :then, t2, :else, t3},
       eval_term(t1) == 'true' && is_v(v2 = eval_term(t2)) && v2},
      # B-IfFalse
      {{:if, t1, :then, t2, :else, t3},
       eval_term(t1) == 'false' && is_v(v3 = eval_term(t3)) && v3},
      # B-Succ
      {{:succ, t1},
       is_nv(nv1 = eval_term(t1)) && {:succ, nv1}},
      # B-PredZero
      {{:pred, t1},
       eval_term(t1) == :'0' && :'0'},
      # B-PredSucc
      {{:pred, t1},
       match?({:succ, _}, t1p = eval_term(t1)) && elem(t1p, 1)},
      # B-IszeroZero
      {{:iszero, t1},
       (eval_term(t1) == :'0') && 'true'},
      # B-IszeroSucc
      {{:iszero, t1},
       match?({:succ, _}, eval_term(t1)) && 'false'},
      # [other]
      {other, other},
    ])
  end

  def eval(str) do
    with {:ok, ast} <- to_ast(str) do
      eval_term(ast) |> from_ast
    end
  end
end

