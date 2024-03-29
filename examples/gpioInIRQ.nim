## Example code to use GPIO as input and IRQ.
## When GPIO2 is connect to 3V3(OUT), `gpioIrqHandler` is called.

import picosdk4nim
import picosdk4nim/[gpio, sync, stdio]
import hidecmakelinkerpkg/libconf

writeHideCMakeToFile()

var turnOn = false

proc gpioIrqHandler(gpio: Gpio, evt: set[IrqLevel]) {.cDecl.} =
  turnOn = true

stdioInitAll()

const inputGpio = 2.Gpio
inputGpio.setFunction(SIO)
inputGpio.setDir(false)
inputGpio.pullDown()
const IrqLevelSet = {IrqLevel.fall}
inputGpio.enableIrqWithCallback(IrqLevelSet, true, gpioIrqHandler)

var
  count = 0
  noCount = 0
while true:
  wfi()
  let irqState = saveAndDisableInterrupts()
  memFenceAcquire()
  let isTurnOn = turnOn
  if turnOn:
    turnOn = false
  irqState.restoreInterrupts()
  memFenceRelease()

  if isTurnOn:
    echo "TurnOn:", count
    inc count
  else:
    echo "Not TurnOn:", noCount
    inc noCount
