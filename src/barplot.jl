
function barplot{T,N<:Real}(io::IO, text::Vector{T}, heights::Vector{N};
                            border=:solid, title::String="",
                            margin::Int=3, color::Symbol=:blue,
                            width::Int=40, labels::Bool=true)
  margin >= 0 || throw(ArgumentError("Margin must be greater than or equal to 0"))
  length(text) == length(heights) || throw(DimensionMismatch("The given vectors must be of the same length"))
  width > 0 || throw(ArgumentError("the given width has to be positive"))
  b=borderMap[border]
  maxLen = labels ? max([length(string(l)) for l in text]...):0
  min(heights...) >= 0 || throw(ArgumentError("All values have to be positive"))
  maxFreq = max(heights...)
  maxFreqLen = length(string(maxFreq))
  plotOffset = maxLen + margin
  borderPadding = repeat(" ", plotOffset)
  drawTitle(io, borderPadding, title)
  borderWidth = width + maxFreqLen + 2
  drawBorderTop(io, borderPadding, borderWidth, border)
  print(io, "\n")
  for (label, height) in zip(text, heights)
    str = labels ? string(label): ""
    len = length(str)
    pad = string(repeat(" ", margin),repeat(" ", maxLen - len))
    bar = maxFreq > 0 ? repeat("▪", safeRound(height / maxFreq * width)): ""
    lbl = "$(pad)$(str)$(b[:l])"
    print(io, lbl)
    if isa(io, Base.TTY)
      print_with_color(color, io, bar)
    else
      print(io, bar)
    end
    txt = " $(height)"
    print(io, txt)
    line = string(lbl, bar, txt)
    lineLen = length(line)
    pad = repeat(" ", maxLen + margin + width + maxFreqLen + 3 - lineLen)
    print(io,pad, b[:r], "\n")
  end
  drawBorderBottom(io, borderPadding, borderWidth, border)
  print(io, "\n")
  nothing
end

function barplot{T,N<:Real}(io::IO, dict::Dict{T,N}; args...)
  barplot(STDOUT, collect(keys(dict)), collect(values(dict)); args...)
end

function barplot{T,N<:Real}(labels::Vector{T},heights::Vector{N}; args...)
  barplot(STDOUT, labels, heights; args...)
end

function barplot{T,N<:Real}(dict::Dict{T,N}; args...)
  barplot(STDOUT, dict; args...)
end
