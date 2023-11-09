import std/math
import picosdk4nim
import picosdk4nim/[gpio, time, pwm]
import hidecmakelinkerpkg/libconf

writeHideCMakeToFile()

DefaultLedPin.setFunction PWM
let sliceNum = toSliceNum(DefaultLedPin)
sliceNum.setWrap uint16.high
sliceNum.setChanLevel B, 0
sliceNum.setEnabled true

var
  c: uint8
  mode: range[0 .. 2] # 0: linear. 1: exponential, Fechner's law. 2: squared, Stevens' power law.
  absTime = getTime()
while true:
  if c == 255:
    c = 0
    if mode == 2:
      mode = 0
    else:
      inc mode
  else:
    inc c
  let power = case mode:
              of 0:
                c.uint16 * 255
              of 1:
                pow(pow(float(255 * 255), 1/255), c.float).uint16
              of 2:
                c.uint16 * c.uint16
  sleep(20)
  sliceNum.setChanLevel B, power
