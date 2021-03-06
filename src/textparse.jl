import TextParse: tryparsenext

function _iterate(parser::AbstractToken, sequence, till, before_i, next_i, state,opts=TextParse.default_opts)
    if parser isa CombinedParser
        @warn "define _iterate(parser::$(typeof(parser)), sequence, till, start_i, next_i, state::$(typeof(state)))"
        return nothing
    end
    if state === nothing
        r,next_i_ = tryparsenext(parser, sequence, next_i, till,opts)
        if isnull(r)
            nothing
        else
            NCodeunitsState(next_i,next_i_,get(r))
        end
    else
        nothing
    end
end

"""
    TextParse.tryparsenext(x::CombinedParser,str,i,till,opts=TextParse.default_opts)

TextParse.jl integrates with CombinedParsers.jl both ways.

```jldoctest
julia> using TextParse

julia> p = ("Number:" * Repeat(' ') * TextParse.Numeric(Int))[3]
🗄 Sequence[3]
├─ Number\\:
├─ \\ *  |> Repeat
└─ <Int64>
::Int64

julia> parse(p, "Number:    42")
42

julia> TextParse.tryparsenext(p, "Number:    42")
(Nullable{Int64}(42), 14)
```

"""
function TextParse.tryparsenext(x::CombinedParser,str,i,till,opts=TextParse.default_opts)
    s = _iterate(x,str,till,i,nothing)
    if s === nothing
        Nullable{result_type(x)}(),i
    else
        Nullable(get(x,str,till,tuple_pos(s),i,tuple_state(s))),tuple_pos(s)
    end
end























