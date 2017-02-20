defmodule Tapl.Chapter4.Astifier do
  def to_ast(str) do
    with {:ok, tokens, _} <- :ch4_lexer.string(str) do
      :ch4_parser.parse(tokens)
    end
  end
end

