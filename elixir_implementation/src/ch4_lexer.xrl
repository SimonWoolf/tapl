Definitions.

TOKEN      = [a-z0-9]+
WHITESPACE = [\s\t\n\r]
BRACKETS   = [\(\)]

Rules.

{TOKEN}       : {token, {list_to_atom(TokenChars), TokenLine}}.
{WHITESPACE}+ : skip_token.
{BRACKETS}+   : skip_token.

Erlang code.
