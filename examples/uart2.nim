import picosdk4nim
import picosdk4nim/[gpio, uart]
import hidecmakelinkerpkg/libconf

writeHideCMakeToFile()

uartInit(uart0, 115200)
setFunction(0.Gpio, UART)
setFunction(1.Gpio, UART)

while true:
  if uart0.uartIsReadableWithinUS(3_000_000):
    let c = uart0.uartGetC
    uart0.uartPutC(c)
  else:
    uart0.uartPuts("\n\rNo input for 3 seconds\n\r")
