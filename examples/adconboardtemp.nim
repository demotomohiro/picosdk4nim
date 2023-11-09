import std/strformat
import picosdk4nim
import picosdk4nim/[stdio, adc, time]
import hidecmakelinkerpkg/libconf

writeHideCMakeToFile()

stdioInitAll()
adcInit()
enableTempSensor(true)
selectInput(AdcTemp)

while true:
  let
    adcRaw = adcRead()
    adcf = adcRaw.float32 * ThreePointThreeConv
    tempC = 27.0f - (adcf - 0.706f) / 0.001721f;
  echo &"Onboard temperature: {tempC:.6}°C / Raw value: {adcRaw}"
  sleep(2000)
