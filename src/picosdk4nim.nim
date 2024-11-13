import picosdk4nim/private/strformatsuppresswarning
import pathX
import hidecmakelinkerpkg/libconf

const PicoSDKPath {.strdefine.} = ""

when PicoSDKPath == "":
  {.error: "Please run 'git clone https://github.com/raspberrypi/pico-sdk.git --branch master --depth 1 --recurse-submodules --shallow-submodules' and specify the path to Raspberry Pi Pico SDK with `-d:PicoSDKPath=/path/to/pico-sdk`".}

const PicoBinaryType {.strdefine.}: string = ""
static: doAssert PicoBinaryType in ["", "default", "no_flash", "copy_to_ram", "blocked_ram"]

when defined(PicoEnableStdioUsb):
  const PicoEnableStdioUsb {.booldefine.} = false
    ## Enable reading from stdout and writing to stdin through USB CDC.
    ## Disabled in default.

when defined(PicoEnableStdioUart):
  const PicoEnableStdioUart {.booldefine.} = false
    ## Enable reading from stdout and writing to stdin through UART.
    ## Enabled in default.

when defined(PicoDefaultUart):
  const PicoDefaultUart {.intdefine.} = 0
    ## Set UART instance for stdio.
    ## Must be 0 or 1
  static: assert PicoDefaultUart in 0 .. 1
when defined(PicoDefaultUartTxPin):
  const PicoDefaultUartTxPin {.intdefine.} = 0
    ## Set UART Tx GPIO pin number used as stdout.
  static: assert PicoDefaultUartTxPin mod 4 == 0 and PicoDefaultUartTxPin in 0 .. 28
when defined(PicoDefaultUartRxPin):
  const PicoDefaultUartRxPin {.intdefine.} = 1
    ## Set UART Rx GPIO pin number used as stdin.
  static: assert PicoDefaultUartRxPin mod 4 == 1 and PicoDefaultUartRxPin in 1 .. 29

const PicoNoPicotool {.booldefine.} = false
  ## When set to true, Pico SDK stop using picotool.
  ## Otherwise, if picotool is not installed on your machine or Pico SDK can't find it,
  ## Pico SDK automatically download and build picotool at build time and it takes long time.
  ##
  ## picotool works with RP2040/RP2350 binaries and interacts RP2040/RP2350 devices.
  ## It is used to create UF2 file by Pico SDK.
  ## https://github.com/raspberrypi/picotool

when defined(PicotoolDir):
  const PicotoolDir {.strdefine.}: string = ""
    ## Set path to the directory containing picotool so that Pico SDK
    ## can call it.

const PicoBoard {.strdefine.}: string = ""
  ## Board name being built for.
  ##
  ## When you add, remove or change this parameter, delete Nim cache directory,
  ## otherwise it causes cmake error or C files are compiled with wrong compile options.
  ##
  ## This is corresponding to `PICO_BOARD` configuration variable.
  ## Fore more info:
  ## "6.2. Platform and Board Configuration" in "Raspberry Pi Pico-Series C/C++ SDK" in https://rptl.io/pico-c-sdk
  ##
  ## - "pico": Raspberry Pi Pico
  ## - "pico2": Raspberry Pi Pico 2
  ## - "pico_w": Raspberry Pi Pico W
  ##
  ## If you use other boards supported by Pico SDK, use the board name in the header file name in:
  ## https://github.com/raspberrypi/pico-sdk/tree/master/src/boards/include/boards

const PicoPlatform {.strdefine.}: string = ""
  ## Platform to build for.
  ##
  ## When you add, remove or change this parameter, delete Nim cache directory,
  ## otherwise it causes cmake error or C files are compiled with wrong compile options.
  ##
  ## This is corresponding to `PICO_PLATFORM` configuration variable.
  ## Fore more info:
  ## "6.2. Platform and Board Configuration" in "Raspberry Pi Pico-Series C/C++ SDK" in https://rptl.io/pico-c-sdk
  ##
  ## - "rp2040": RP2040
  ## - "rp2350-arm-s": RP2350 on Arm processors
  ## - "rp2350-riscv": RP2350 on RISC-V processors

const cmakeStmts = block:
  var res = @[initCMakeInclude($(PicoSDKPath.PathX[:fdDire, arAbso, BuildOS, true].joinFile"pico_sdk_init.cmake"), "includePicoSDK", "std.topStmts"),
              initCMakeCmd("pico_sdk_init()", "initPicoSDK", "std.project")]
  when defined(PicoAddExtraOutput):
    res.add initCMakeCmdWithTarget("pico_add_extra_outputs(#target)")
  when PicoBinaryType != "":
    res.add initCMakeCmdWithTarget("pico_set_binary_type(#target " & PicoBinaryType & ")")
  when compileOption("exceptions", "cpp") and not defined(noCppExceptions):
    # Raspberry Pi Pico SDK disabled C++ exception handling in default to save space
    res.add initCMakeCmd("set(PICO_CXX_ENABLE_EXCEPTIONS 1)")

  when defined(PicoEnableStdioUsb):
    res.add initCMakeCmdWithTarget(fmt"pico_enable_stdio_usb(#target {ord(PicoEnableStdioUsb)})")
  when defined(PicoEnableStdioUart):
    res.add initCMakeCmdWithTarget(fmt"pico_enable_stdio_uart(#target {ord(PicoEnableStdioUart)})")

  when defined(PicoDefaultUart):
    res.add initCMakeCmdWithTarget(fmt"target_compile_definitions(#target PRIVATE PICO_DEFAULT_UART={PicoDefaultUart})")
  when defined(PicoDefaultUartTxPin):
    res.add initCMakeCmdWithTarget(fmt"target_compile_definitions(#target PRIVATE PICO_DEFAULT_UART_TX_PIN={PicoDefaultUartTxPin})")
  when defined(PicoDefaultUartRxPin):
    res.add initCMakeCmdWithTarget(fmt"target_compile_definitions(#target PRIVATE PICO_DEFAULT_UART_RX_PIN={PicoDefaultUartRxPin})")

  when PicoNoPicotool:
    res.add initCMakeCmd("set(PICO_NO_PICOTOOL 1)")

  when defined(PicotoolDir):
    res.add initCMakeCmd(fmt"set(picotool_DIR {PicotoolDir.cmakeStrArg})")

  when PicoBoard != "":
    res.add initCMakeCmd(fmt"set(PICO_BOARD {PicoBoard.cmakeStrArg})")

  when PicoPlatform != "":
    res.add initCMakeCmd(fmt"set(PICO_PLATFORM {PicoPlatform.cmakeStrArg})")

  res

initLibParams(cmakeStmts = cmakeStmts).config()

{.used.}
