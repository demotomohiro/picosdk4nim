import picosdk4nim
import picosdk4nim/[gpio, uart]
import hidecmakelinkerpkg/libconf

writeHideCMakeToFile()

uart0.init(115200)
setFunction(0.Gpio, UART)
setFunction(1.Gpio, UART)

while true:
  if uart0.isReadableWithinUS(3_000_000):
    let c = uart0.getc
    uart0.putc(c)
  else:
    uart0.puts("\n\rNo input for 3 seconds\n\r")
