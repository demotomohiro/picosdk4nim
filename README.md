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
        - Read [Getting Started with the Raspberry Pi Pico-Series](https://rptl.io/pico-get-started)
        - If you are Gentoo Linux user: https://wiki.gentoo.org/wiki/Crossdev
          - Install binutils, gcc, new and gdb targets arm-none-eabi
    - Build or install [OpenOCD](https://github.com/raspberrypi/openocd) if you want to use Picoprobe or Raspberry Pi Debug Probe
        - Read Appendix A: Debugprobe in [Getting Started with the Raspberry Pi Pico-Series](https://rptl.io/pico-get-started)


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

In main module, following code is needed:
```nim
import picosdk4nim
import hidecmakelinkerpkg/libconf

# Call this after importing all modules
writeHideCMakeToFile()
```

Then you can compile `blink.nim` with following command:
```console
$ nim c -d:PicoSDKPath=/path/to/pico-sdk/ blink.nim
```
You can put `-d:PicoSDKPath=/path/to/pico-sdk/` option as `switch("define", "/path/to/pico-sdk")` to `config.nims` in any directories Nim searches for `.nims` configuration files.


## How to load and run a program on Raspberry Pi Pico
There several ways to loading a program to Pico to run and they are not different from programs compiled from C.
See ["Getting Started with the Raspberry Pi Pico-Series"](https://rptl.io/pico-get-started) in [Raspberry Pi Pico SDK](https://github.com/raspberrypi/pico-sdk) for more details.
### Mount Pico as USB Mass Storage Device and copy .uf2 file
1. Build your code with `PicoAddExtraOutput` so that `*.uf2` file is generated
1. Make sure Pico is disconnect from USB or other power source
1. Hold down `BOOTSEL` button on Pico
1. Connect Pico's USB port to your PC
1. Release `BOOTSEL` button on Pico
1. Pico should be recognized as USB storage on your PC
1. Copy `*.uf2` file to the storage

### Loading .elf file to Pico using Picoprobe
Use another Pico as "Picoprobe" and wire it to main Pico.
Use OpenOCD on your PC to load a program to Pico.
You don't need to connect and disconnect Pico to USB port everytime you load updated program.
1. Build your code so that `*.elf` file is generated
1. Build or install OpenOCD (Read "Appendix A: Debugprobe" in [Getting Started with the Raspberry Pi Pico-Series](https://rptl.io/pico-get-started))
1. If you use a second Pico or Pico 2 instead of Debug Probe, install picoprobe (Read Appedix A again) to it
1. Wire Picoprobe to another Pico (Read Appedix A again)
1. Set environment variable `OPENOCD_PATH` to OpenOCD directory so that `$OPENOCD_PATH/src/openocd` refers `openocd` executable
1. Run following command (replace `blink.elf` to your `*.elf` file name):
   ```console
   $ $OPENOCD_PATH/src/openocd -s $OPENOCD_PATH/tcl -f interface/cmsis-dap.cfg -c "adapter speed 5000" -f target/rp2040.cfg -c "program blink.elf verify reset exit"
   ```

### Loading .elf file to Pico using Picoprobe without writing to flash memory
Requires Picoprobe, OpenOCD and GDB.
Loaded program will be lost when Pico lost power or reset.
1. Build your code with `-d:PicoBinaryType=no_flash`
1. Install GDB (gdb-multiarch or arm-none-eabi-gdb)
1. Build OpenOCD (Read Appendix A: Debugprobe in [Getting Started with the Raspberry Pi Pico-Series](https://rptl.io/pico-get-started))
1. If you use a second Pico or Pico 2 instead of Debug Probe, install picoprobe (Read Appedix A again) to it
1. Wire Picoprobe to another Pico (Read Appedix A again)
1. Set environment variable `OPENOCD_PATH` to OpenOCD directory so that `$OPENOCD_PATH/src/openocd` refers `openocd` executable
1. Run following command:
   ```console
   $ $OPENOCD_PATH/src/openocd -s $OPENOCD_PATH/tcl -f interface/cmsis-dap.cfg -c "adapter speed 5000" -f target/rp2040.cfg
   ```
1. Open another terminal and run following command (replace `blink.elf` to your `*.elf` file name):
   ```console
   $ gdb-multiarch blink.elf
   ```
   If you use Gentoo Linux:
   ```console
   $ arm-none-eabi-gdb blink.elf
   ```
1. Connect to OpenOCD on GDB
   ```console
   (gdb) target extended-remote localhost:3333
   ```
1. Run following commands on GDB
   ```console
   (gdb) monitor reset init
   (gdb) load
   (gdb) continue
   ```

When you change your code and build a new program, press 'c' key with ctrl key on GDB and run following commands again
```console
(gdb) monitor reset init
(gdb) load
(gdb) continue
```

You can define User-defined Commands using `define` on GDB:
```console
(gdb) define reload
>monitor reset init
>load
>continue
>end
```
This commands can be placed on GDB's initialization file.


## Build options
There are build options on `src/picosdk4nim.nim`. They can be set with compiler option like `-d:option=value` or `switch` proc like `switch("define", "option=value")` on `config.nims` file.

Some of build options are corresponding to CMake build configurations/functions of Raspberry Pi Pico-series C/C++ SDK.
List of these options are explained in [Chapter 6~7 on Raspberry Pi Pico-Series C/C++ SDK](https://rptl.io/pico-c-sdk).
