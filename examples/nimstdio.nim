import std/strutils
import picosdk4nim
import picosdk4nim/[stdio, time]
import hidecmakelinkerpkg/libconf

writeHideCMakeToFile()

proc readLine: string =
  while true:
    let c = stdin.readChar()
    if c == '\r':
      stdout.write '\n'
      break
    elif c < ' ':
      if c == '\b':
        if result.len > 0:
          stdout.write "\b \b"
          stdout.flushFile()
          result.setLen(result.len - 1)
      elif c == '\e':
        # Escape sequences is not implemented
        discard
      else:
        echo c.int
    else:
      stdout.write c
      stdout.flushFile()
      result.add c

stdioInitAll()

echo CompileDate, " ", CompileTime
echo "This is minimum calculator runs on Raspberry Pi Pico"

var numStack: seq[int]

while true:
  echo numStack
  stdout.write "> "
  stdout.flushFile()
  let userInput = readLine()
  if userInput in ["+", "-"]:
    if numStack.len < 2:
      echo "Requires at least 2 numbers in stack"
    else:
      let x = numStack.pop
      if userInput == "+":
        numStack[^1] += x
      elif userInput == "-":
        numStack[^1] -= x
  else:
    try:
      let n = parseInt(userInput)
      numStack.add n
    except ValueError:
      echo "Write integer or +/-"
  #sleep(1000)
