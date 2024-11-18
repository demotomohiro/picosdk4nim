import std/[math]
import picosdk4nim
import picosdk4nim/[stdio, adc, time]
import hidecmakelinkerpkg/libconf

writeHideCMakeToFile()

stdioInitAll()
adcInit()

selectInput(Adc26)

var sampleBuf: array[16, uint16]

adcFifoSetup(true, false, 0, true, false)

while true:
  adcRun(true)

  for i in sampleBuf.mitems:
    i = adcFifoGetBlocking()

  adcRun(false)
  adcFifoDrain()

  # Clear screen and move cursor to top left.
  stdout.write "\e[2J"

  for i in sampleBuf:
    if (i and 0x8000) != 0:
      echo "Err"
    else:
      # Suppose when ADC read 3.3 volt, it returns 4095.
      # RP2040 and RP2350 has 12-bit ADC.
      const
        SampleMilliVoltMax = 33000u32 # milli volt * 10
        ADCBits = 12
      echo i, " / ", i * SampleMilliVoltMax div (2u32^ADCBits - 1)

  sleep(1000)
