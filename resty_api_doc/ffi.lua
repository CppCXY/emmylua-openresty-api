ffi={}

function ffi.typeinfo() end
---Creates a cdata object for the given ct. VLA/VLS types require the nelem argument. 
---The second syntax uses a ctype as a constructor and is otherwise fully equivalent.
---
---The cdata object is initialized according to the rules for initializers, 
---using the optional init arguments. Excess initializers cause an error.
---
---Performance notice: if you want to create many objects of one kind,
--- parse the cdecl only once and get its ctype with ffi.typeof(). 
---
---Then use the ctype as a constructor repeatedly.
---
---Please note that an anonymous struct declaration implicitly creates a new
--- and distinguished ctype every time you use it for ffi.new(). This is probably not
--- what you want, especially if you create more than one cdata object. 
---Different anonymous structs are not considered assignment-compatible by the C standard, 
---even though they may have the same fields! Also, they are considered different types 
---by the JIT-compiler, which may cause an excessive number of traces. It's strongly suggested 
---to either declare a named struct or typedef with ffi.cdef() or to create a single
---ctype object for an anonymous struct with ffi.typeof().
---@param c_struct_desc string | ctype
---@vararg any @elem init the struct
---@return userdata
function ffi.new(c_struct_desc,...) end
ffi.arch="x64"
---Creates a ctype object for the given ct and associates it with a metatable. 
---Only struct/union types, complex numbers and vectors are allowed. 
---Other types may be wrapped in a struct, if needed.
---
---The association with a metatable is permanent and cannot be changed afterwards. 
---Neither the contents of the metatable nor the contents of an __index table 
---(if any) may be modified afterwards. The associated metatable automatically 
---applies to all uses of this type, no matter how the objects are created or where 
---they originate from. Note that pre-defined operations on types have precedence
--- (e.g. declared field names cannot be overriden).
---
---All standard Lua metamethods are implemented. These are called directly, 
---without shortcuts and on any mix of types. For binary operations, the left operand
---is checked first for a valid ctype metamethod. The __gc metamethod only applies 
---to struct/union types and performs an implicit ffi.gc() call during creation of an instance.
---@param ct string
---@param metatable table
---@return userdata
function ffi.metatype(ct,metatable) end
---Adds multiple C declarations for types or external symbols (named variables or functions). 
---def must be a Lua string. It's recommended to use the syntactic sugar for string arguments 
---as follows:
---ffi.cdef[[
---typedef struct foo { int a, b; } foo_t;  // Declare a struct and typedef.
---int dofoo(foo_t *f, int n);  /* Declare an external C function. */
---]]
---The contents of the string (the part in green above) must be a sequence of C declarations, 
---separated by semicolons. The trailing semicolon for a single declaration may be omitted.
---
---Please note that external symbols are only declared, but they are not bound to any specific address, yet. 
---Binding is achieved with C library namespaces (see below)
---C declarations are not passed through a C pre-processor, yet. No pre-processor tokens are allowed, 
---except for #pragma pack. Replace #define in existing C header files with enum, static const or 
---typedef and/or pass the files through an external C pre-processor (once). Be careful not to include 
---unneeded or redundant declarations from unrelated header files.
---@param def string
function ffi.cdef(def) end
---Returns the size of ct in bytes. Returns nil if the size is not known 
---(e.g. for "void" or function types).
---Requires nelem for VLA/VLS types, except for cdata objects.
---@param ct string
---@return number
function ffi.sizeof(ct) end
---Returns the minimum required alignment for ct in bytes.
---@param ct string
---@return number
function ffi.alignof(ct) end
---Copies the data pointed to by src to dst. dst is converted to a "void *" and src is converted 
---to a "const void *".
---In the first syntax, len gives the number of bytes to copy. Caveat: if src is a Lua string, then len must not exceed #src+1.
---In the second syntax, the source of the copy must be a Lua string. All bytes of the string plus a zero-terminator are copied to dst (i.e. #src+1 bytes).
---Performance notice: ffi.copy() may be used as a faster (inlinable) replacement for the C library functions memcpy(), strcpy() and strncpy().
---@overload fun(dst:userdata,str:string)
---@param dst userdata
---@param src userdata
---@param len number
function ffi.copy(dst,src,len) end
---Creates a ctype object for the given ct.
---This function is especially useful to parse a cdecl only once and then use the
---resulting ctype object as a constructor.
---@param ct string
---@return ctype
function ffi.typeof(ct) end
---Returns the error number set by the last C function call which indicated an error condition.
--- If the optional newerr argument is present, the error number is set to the new value and
--- the previous value is returned.
---
---This function offers a portable and OS-independent way to get and set the error number. 
---Note that only some C functions set the error number. And it's only significant if the function 
---actually indicated an error condition (e.g. with a return value of -1 or NULL). Otherwise,
---it may or may not contain any previously set value.
---You're advised to call this function only when needed and as close as possible after 
---the return of the related C function. The errno value is preserved across hooks, 
---memory allocations, invocations of the JIT compiler and other internal VM activity. 
---The same applies to the value returned by GetLastError() on Windows, but you need to
---declare and call it yourself.
---@param newerr string
---@return number @err
function ffi.errno(newerr) end
---Returns true if obj has the C type given by ct. Returns false otherwise.
---C type qualifiers (const etc.) are ignored. Pointers are checked with the standard pointer 
---compatibility rules, but without any special treatment for void *. 
---If ct specifies a struct/union, then a pointer to this type is accepted, too.
--- Otherwise the types must match exactly.
---Note: this function accepts all kinds of Lua objects for the obj argument, 
---but always returns false for non-cdata objects
---@param ct ctype
---@param obj cdata
function ffi.istype(ct,obj) end
---This is the default C library namespace — note the uppercase 'C'. 
---It binds to the default set of symbols or libraries on the target system. 
---These are more or less the same as a C compiler would offer by default,
--- without specifying extra link libraries.
---
---On POSIX systems, this binds to symbols in the default or global namespace. 
---This includes all exported symbols from the executable and any libraries loaded 
---into the global namespace. This includes at least libc, libm, libdl (on Linux),
--- libgcc (if compiled with GCC), as well as any exported symbols from the Lua/C API 
---provided by LuaJIT itself.
---
---On Windows systems, this binds to symbols exported from the *.exe, 
---the lua51.dll (i.e. the Lua/C API provided by LuaJIT itself), the C runtime 
---library LuaJIT was linked with (msvcrt*.dll), kernel32.dll, user32.dll and gdi32.dll.
ffi.C={}
ffi.os="Linux"
---Creates a scalar cdata object for the given ct. The cdata object is initialized with 
---init using the "cast" variant of the C type conversion rules.
---
---This functions is mainly useful to override the pointer compatibility checks 
---or to convert pointers to addresses or vice versa.
---@param ct string
---@param init any
---@return userdata
function ffi.cast(ct,init) end
---This loads the dynamic library given by name and returns a new C library namespace
--- which binds to its symbols. On POSIX systems, if global is true, the library symbols 
---are loaded into the global namespace, too.
---
---If name is a path, the library is loaded from this path. Otherwise name is canonicalized
--- in a system-dependent way and searched in the default search path for dynamic libraries:
---
---On POSIX systems, if the name contains no dot, the extension .so is appended. 
---Also, the lib prefix is prepended if necessary. So ffi.load("z") looks for "libz.so" in the default shared library search path.
---
---On Windows systems, if the name contains no dot, the extension .dll is appended. 
---So ffi.load("ws2_32") looks for "ws2_32.dll" in the default DLL search path.
---@param name string@libname
---@param global boolean@is load into gloabl table
---@return table
function ffi.load(name,global) end
---Creates an interned Lua string from the data pointed to by ptr.
---
---If the optional argument len is missing, ptr is converted to a "char *"
---and the data is assumed to be zero-terminated. The length of the string
---is computed with strlen().
---
---Otherwise ptr is converted to a "void *" and len gives the length of the data. 
---The data may contain embedded zeros and need not be byte-oriented (though this may cause endianess
--- issues).
---
---This function is mainly useful to convert (temporary) "const char *" pointers returned 
---by C functions to Lua strings and store them or pass them to other functions expecting
--- a Lua string. The Lua string is an (interned) copy of the data and bears no relation 
---to the original data area anymore. Lua strings are 8 bit clean and may be used to hold 
---arbitrary, non-character data.
---Performance notice: it's faster to pass the length of the string, if it's known. E.g. 
---when the length is returned by a C call like sprintf().
---@param ptr C_pointer
---@param len number
---@return string
function ffi.string(ptr,len) end
function ffi.gc() end
---Returns true if param (a Lua string) applies for the target ABI (Application Binary Interface).
---Returns false otherwise. 
---@param param string
---@return boolean
function ffi.abi(param) end
---Fills the data pointed to by dst with len constant bytes, 
---given by c. If c is omitted, the data is zero-filled.
---Performance notice: ffi.fill() may be used as a faster (inlinable) replacement 
---for the C library function memset(dst, c, len). Please note the different order of arguments!
function ffi.fill(dst,len,c) end
---Returns the offset (in bytes) of field relative to the start of ct, 
---which must be a struct. Additionally returns the position and the 
---field size (in bits) for bit fields.
function ffi.offsetof(ct,field) end
return ffi