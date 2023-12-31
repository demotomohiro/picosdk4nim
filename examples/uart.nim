import picosdk4nim
import picosdk4nim/[gpio, uart]
import hidecmakelinkerpkg/libconf

writeHideCMakeToFile()

uart0.init(115200)
setFunction(0.Gpio, UART)
setFunction(1.Gpio, UART)

while true:
  var c = uart0.getc
  if c in {'a' .. 'z'}:
    if c == 'z':
      c = 'a'
    else:
      inc c
  uart0.putc(c)
