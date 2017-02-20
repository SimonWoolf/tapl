Terminals 'true' 'false' '0' 'if' 'else' 'then' 'succ' 'pred' 'iszero'.
Nonterminals term.
Rootsymbol term.

term        -> 'true'                            : "true".
term        -> 'false'                           : "false".
term        -> 'if' term 'then' term 'else' term : {'if', '$2', 'then', '$4', 'else', '$6'}.
term        -> '0'                               : '0'.
term        -> 'succ' term                       : {'succ', '$2'}.
term        -> 'pred' term                       : {'pred', '$2'}.
term        -> 'iszero' term                     : {'iszero', '$2'}.

Erlang code.
