jit={}
function jit.attach() end
function jit.prngstate() end
--- Turns the whole JIT compiler on (default) or off.
--- These functions are typically used with the command line options -j on or -j off.
function jit.on() end
jit.version="LuaJIT 2.1.0-beta3"
jit.os="Linux"
--- Turns the whole JIT compiler on (default) or off.
--- These functions are typically used with the command line options -j on or -j off.
function jit.off() end
---Flushes the whole cache of compiled code.
---Flushes the root trace, specified by its number, and all of its side traces from the cache. 
---The code for the trace will be retained as long as there are any other traces which link to it.
---@param tr number
function jit.flush(tr) end
jit.version_num=20100
jit.opt={}
--- This sub-module provides the backend for the -O command line option.
--- You can also use it programmatically, e.g.
---
--- jit.opt.start(2) -- same as -O2
--- jit.opt.start("-dce")
--- jit.opt.start("hotloop=10", "hotexit=2")
--- Unlike in LuaJIT 1.x, the module is built-in and optimization is turned on by default! It's no longer 
--- necessary to run require("jit.opt").start(), which was one of the ways to enable optimization.
---@vararg number | string
function jit.opt.start(...) end
jit.arch="x64"
---Returns the current status of the JIT compiler. The first result is either true or false if the JIT 
---compiler is turned on or off. The remaining results are strings for CPU-specific features and enabled optimizations.
---@return status,...
function jit.status() end
return jit