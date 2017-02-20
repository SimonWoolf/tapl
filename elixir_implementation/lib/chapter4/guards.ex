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
end
