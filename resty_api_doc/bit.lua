bit={}

---Converts its first argument to a hex string. 
---The number of hex digits is given by the absolute value of the 
---optional second argument. Positive numbers between 1 and 8 
---generate lowercase hex digits. Negative numbers generate uppercase
---hex digits. Only the least-significant 4*|n| bits are used. 
---The default is to generate 8 lowercase hex digits.
---print(bit.tohex(1))              --> 00000001
---print(bit.tohex(-1))             --> ffffffff
---print(bit.tohex(0xffffffff))     --> ffffffff
---print(bit.tohex(-1, -8))         --> FFFFFFFF
---print(bit.tohex(0x21, 4))        --> 0021
---print(bit.tohex(0x87654321, 4))  --> 4321
---@param x number
---@param n number
---@return string
function bit.tohex(x,n) end
---Returns either the bitwise left rotation, or bitwise right
--- rotation of its first argument by the number of bits given
---by the second argument. Bits shifted out on one side are shifted 
---back in on the other side.
---Only the lower 5 bits of the rotate count are used (reduces to the range [0..31]).
---printx(bit.rol(0x12345678, 12))   --> 0x45678123
---printx(bit.ror(0x12345678, 12))   --> 0x67812345
---@param x number
---@param n number
---@return number
function bit.rol(x,n) end
---@param x number
---@param n number
---@return number
function bit.ror(x,n) end


---Normalizes a number to the numeric range for bit operations and returns it. 
---This function is usually not needed since all bit operations already normalize 
---all of their input arguments. Check the operational semantics for details.
---print(0xffffffff)                --> 4294967295 (*)
---print(bit.tobit(0xffffffff))     --> -1
---printx(bit.tobit(0xffffffff))    --> 0xffffffff
---print(bit.tobit(0xffffffff + 1)) --> 0
---print(bit.tobit(2^40 + 1234))    --> 1234
---(*) See the treatment of hex literals for an explanation why the printed numbers
---in the first two lines differ (if your Lua installation uses a double number type).
---@param x number
---@return number
function bit.tobit(x) end
---Swaps the bytes of its argument and returns it.
--- This can be used to convert little-endian 32 bit numbers 
---to big-endian 32 bit numbers or vice versa.
---printx(bit.bswap(0x12345678)) --> 0x78563412
---printx(bit.bswap(0x78563412)) --> 0x12345678
---@param x number
---@return number
function bit.bswap(x) end
---@param x number
---@vararg number
---@return number
function bit.band(x,...) end
---@param x number
---@vararg number
---@return number
function bit.bxor(x,...) end
---@param x number
---@vararg number
---@return number
function bit.bor(x,...) end
---Returns either the bitwise logical left-shift, bitwise logical right-shift, 
---or bitwise arithmetic right-shift of its first argument by the number of 
---bits given by the second argument.
---Logical shifts treat the first argument as an unsigned number and shift 
---in 0-bits. Arithmetic right-shift treats the most-significant bit as a sign bit 
---and replicates it.
---Only the lower 5 bits of the shift count are used (reduces to the range [0..31]).
---logical right shift
---@param x number
---@param n number
---@return number
function bit.rshift(x,n) end
---arithmetic right shift
---@param x number
---@param n number
---@return number
function bit.arshift(x,n) end
---logical left shift
---@param x number
---@param n number
---@return number
function bit.lshift(x,n) end

---Returns the bitwise not of its argument.
---print(bit.bnot(0))            --> -1
---printx(bit.bnot(0))           --> 0xffffffff
---print(bit.bnot(-1))           --> 0
---print(bit.bnot(0xffffffff))   --> 0
---printx(bit.bnot(0x12345678))  --> 0xedcba987
---@param x number
---@return number
function bit.bnot(x) end
return bit