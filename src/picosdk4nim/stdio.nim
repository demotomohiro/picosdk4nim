import hidecmakelinkerpkg/libconf

initLibParams(linkLibraries = ["pico_stdlib"]).config()

{.push header: "pico/stdio.h".}
proc stdioInitAll*{.importc: "stdio_init_all".}
  ## Initialize all of the present standard stdio types that are linked into the 
  ## binary.
  ## 
  ## Call this method once you have set up your clocks to enable the stdio 
  ## support for UART, USB and semihosting based on the presence of the 
  ## respective libraries in the binary.


proc getCharWithTimeout*(timeout: uint32): char {.importC: "getchar_timeout_us".} 
  ## Return a character from stdin if there is one available within a timeout.
  ## 
  ## **Parameters:**
  ## 
  ## ===========  ====== 
  ## **timeout**   the timeout in microseconds, or 0 to not wait for a character if none available.
  ## ===========  ======
  ## 
  ## **Returns:** the character from 0-255 or PICO_ERROR_TIMEOUT if timeout occurs  
{.pop.}

{.push header: "pico/stdio_usb.h".}
proc stdioInitUsb*: bool{.importC: "stdio_usb_init".}
  ## Explicitly initialize USB stdio and add it to the current set of stdin 
  ## drivers. 

proc usbConnected*: bool {.importC: "stdio_usb_connected".}
  ## Returns true if USB uart is connected.
{.pop.}


proc blockUntilUsbConnected*() =
  ## Blocks until the usb is connected, useful if reliant on USB interface.
  while not usbConnected(): discard
