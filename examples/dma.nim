import picosdk4nim
import picosdk4nim/[dma, stdio]
import hidecmakelinkerpkg/libconf

writeHideCMakeToFile()

let testText = "Hello world from DMA"

stdioInitAll()

proc main =
  let
    channel = dmaClaimUnusedChannel(true)
    config = channel.getDefaultConfig

  config.setTransferDataSize(SIZE8)
  config.setReadIncrement(true)
  config.setWriteIncrement(true)

  var
    dstText = newString(testText.len)

  channel.configure(config, addr dstText[0], addr testText[0], testText.len.cuint, true)
  channel.waitForFinishBlocking

  doAssert dstText == testText

  echo dstText

main()
