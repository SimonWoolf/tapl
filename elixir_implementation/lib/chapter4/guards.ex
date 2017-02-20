defmodule Tapl.Chapter4.Guards do
  defmacro is_numeric_val(term, max_recursion) do
    if(max_recursion > 0) do
      quote do
        unquote(term) == :"0" or (
           is_tuple(unquote(term)) and
           elem(unquote(term), 0) == :succ and
           is_numeric_val(elem(unquote(term), 1), unquote(max_recursion - 1))
         )
       end
    end
  end

  defmacro bigstep_rule(term, clauses) do
    tests = Enum.map(clauses, fn(clause) -> bigstep_helper(term, clause) end)
    quote do
      cond do
        unquote(List.flatten(tests))
      end
    end
  end

  defp bigstep_helper(term, c = {match, prerequisite}) do
    quote do
      match?(unquote(match), unquote(term)) &&
        (unquote(match) = unquote(term))    &&
        (result = unquote(prerequisite))    &&
        result -> result
    end
  end
end
