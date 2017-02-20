defmodule Tapl.Chapter4.Astifier do
  def to_ast(str) do
    with {:ok, tokens, _} <- :ch4_lexer.string(str) do
      :ch4_parser.parse(tokens)
    end
  end

  def from_ast(term) when is_tuple(term) do
    term
    |> Tuple.to_list
    |> Enum.map(&from_ast/1)
    |> Enum.intersperse(' ')
    |> List.flatten
  end

  def from_ast(term) when is_atom(term) do
    to_charlist(term)
  end
end

