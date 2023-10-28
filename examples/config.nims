switch("path", "$projectDir/../src")
switch("define", "release")
switch("mm", "arc") # use "arc", "orc" or "none"
switch("define", "checkAbi")
switch("define", "useMalloc")
switch("cpu", "arm")
switch("os", "any")
switch("threads", "off")
# If you use C++ backend:
# "quirk" works with C++ backend and produce smallest code, but you would better to learn how it works.
#   See: https://nim-lang.org/araq/quirky_exceptions.html
#        https://github.com/nim-lang/Nim/issues/10713
# "setjmp" works with C++ backend but produced code is larger than quirk. It needs `switch("define", "noCppExceptions")`.
# "cpp" is the default when compiling with C++ backend. It works but produces largest code. You might need to use this when using C++ libraries that throw C++ exceptions.
# "goto" might not work with C++ backend.
#   See: https://github.com/nim-lang/Nim/issues/22686#issuecomment-1713374179
#switch("exceptions", "setjmp")
#switch("define", "noCppExceptions")

switch("gcc.linkerexe", "hidecmakelinker")
switch("gcc.cpp.linkerexe", "hidecmakelinker")
switch("gcc.exe", "void")
switch("gcc.cpp.exe", "void")
nimcacheDir().mkDir()

switch("define", "PicoAddExtraOutput")
# switch("define", "PicoBinaryType=no_flash")
