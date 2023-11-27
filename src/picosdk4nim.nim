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

const cmakeStmts = block:
  var res = @[initCMakeInclude($(PicoSDKPath.PathX[:fdDire, arAbso, BuildOS, true].joinFile"pico_sdk_init.cmake"), "includePicoSDK"),
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

  res

initLibParams(cmakeStmts = cmakeStmts).config()

{.used.}
