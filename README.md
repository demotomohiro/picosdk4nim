# PicoSDK4Nim
This is a library to write [Nim](https://nim-lang.org) code for Raspberry Pi Pico and wraps [Raspberry Pi Pico SDK](https://github.com/raspberrypi/pico-sdk).

## There is already Raspberry Pi Pico SDK for Nim. Why created another tool?
By using this library with [hidecmakelinker](https://github.com/demotomohiro/hidecmakelinker) and write `config.nims`, you can build your code with `nim c blink.nim` and it doesn't require nimble.
You can wrap C libraries related to Raspberry Pi Pico on Nim module and use it without adding code to build tools.

## Requirements
- Nim 2.0.0
- [hidecmakelinker](https://github.com/demotomohiro/hidecmakelinker)
    - CMake 3.13 or newer
- [pathX](https://github.com/demotomohiro/pathX)
- Raspberry Pi Pico SDK
```console
git clone https://github.com/raspberrypi/pico-sdk.git --branch master --depth 1 --recurse-submodules --shallow-submodules
```
- Build tools required by Raspberry Pi Pico SDK
    - For more details: https://github.com/raspberrypi/pico-sdk
        - Read "Getting Started with the Raspberry Pi Pico"
        - If you are Gentoo Linux user: https://wiki.gentoo.org/wiki/Crossdev
    - Build OpenOCD if you want to use Picoprobe or Raspberry Pi Debug Probe

## How to install
Before installing picosdk4nim, make sure that build tools, CMake and Raspberry Pi Pico SDK are installed, and you can build example C code with `CMakeLists.txt` in https://github.com/raspberrypi/pico-sdk/blob/master/README.md

Install using nimble:
```console
$ nimble install https://github.com/demotomohiro/picosdk4nim
```
or install pathX and hidecmakelinker, and clone the project and set Nim import path so that you can import modules in `src` directory:
```console
$ git clone https://github.com/demotomohiro/picosdk4nim.git
```

## How to use
Create `config.nims` with following content:
```nim
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

# If you want .uf2 file
switch("define", "PicoAddExtraOutput")
```

Then you can compile `blink.nim` with following command:
```console
$ nim c -d:PicoSDKPath=/path/to/pico-sdk/ blink.nim
```
You can put `-d:PicoSDKPath=/path/to/pico-sdk/` option as `switch("define", "/path/to/pico-sdk")` to `config.nims` in any directories Nim searches for `.nims` configuration files.
