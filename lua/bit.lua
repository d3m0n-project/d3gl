local bit = {}

function bit.band(a, b) return a & b end
function bit.bor(a, b) return a | b end
function bit.lshift(a, n) return (a << n) & 0xffffffff end
function bit.rshift(a, n) return (a & 0xffffffff) >> n end
function bit.tobit(a) return math.floor(a) & 0xffffffff end

return bit
