import hidecmakelinkerpkg/libconf

initLibParams(linkLibraries = ["hardware_uart"]).config()

{.push header: "hardware/uart.h".}

type
  UartInst* {.importc: "uart_inst_t".} = object

let
  uart0* {.importc: "uart0".}: ptr UartInst
  uart1* {.importc: "uart0".}: ptr UartInst

proc uartDeinit*(uart: ptr UartInst) {.importc: "uart_deinit".}
proc uartGetIndex*(uart: ptr UartInst): cuint {.importc: "uart_get_index".}
proc uartGetC*(uart: ptr UartInst): cchar {.importc: "uart_getc".}
proc uartInit*(uart: ptr UartInst; baudrate: cuint) {.importc: "uart_init".}
proc uartIsEnabled*(uart: ptr UartInst): bool {.importc: "uart_is_enabled".}
proc uartIsReadable*(uart: ptr UartInst): bool {.importc: "uart_is_readable".}
proc uartIsReadableWithinUS*(uart: ptr UartInst; us: uint32): bool {.importc: " uart_is_readable_within_us".}
proc uartIsWritable*(uart: ptr UartInst): bool {.importc: "uart_is_writable".}
proc uartPutC*(uart: ptr UartInst; c: cchar) {.importc: "uart_putc".}
proc uartPutCRaw*(uart: ptr UartInst; c: cchar) {.importc: "uart_putc_raw".}
proc uartPuts*(uart: ptr UartInst; s: cstring) {.importc: "uart_puts".}
proc uartReadBlocking*(uart: ptr UartInst; dst: uint8; len: csize_t) {.importc: "uart_read_blocking".}
proc uartDefaultTxWaitBlocking*(){.importC: "uart_default_tx_wait_blocking".}
  ## Wait for the default UART'S TX fifo to be drained.

{.pop.}
