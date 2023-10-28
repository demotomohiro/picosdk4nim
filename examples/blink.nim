import picosdk4nim
import picosdk4nim/[stdio, gpio, time]
import hidecmakelinkerpkg/libconf

writeHideCMakeToFile()

stdioInitAll()
DefaultLedPin.init()
DefaultLedPin.setDir(Out)
while true:
  for i in 0..4:
    DefaultLedPin.put(Low)
    sleep(100)
    DefaultLedPin.put(High)
    sleep(100)
  echo "Test message from pico"
  sleep(1000)
