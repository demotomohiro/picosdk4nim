import hidecmakelinkerpkg/libconf

initLibParams(linkLibraries = ["hardware_uart"]).config()

{.push header: "hardware/uart.h".}

type
  UartInst* {.importc: "uart_inst_t".} = object

let
  uart0* {.importc: "uart0".}: ptr UartInst
  uart1* {.importc: "uart1".}: ptr UartInst

proc getIndex*(uart: ptr UartInst): cuint {.importc: "uart_get_index".}
proc init*(uart: ptr UartInst; baudrate: cuint) {.importc: "uart_init".}
proc deinit*(uart: ptr UartInst) {.importc: "uart_deinit".}
proc setIrqEnables*(uart: ptr UartInst; rx_has_data, tx_needs_data: bool) {.importc: "uart_set_irq_enables".}
proc isEnabled*(uart: ptr UartInst): bool {.importc: "uart_is_enabled".}
proc isWritable*(uart: ptr UartInst): bool {.importc: "uart_is_writable".}
proc isReadable*(uart: ptr UartInst): bool {.importc: "uart_is_readable".}
proc isReadableWithinUS*(uart: ptr UartInst; us: uint32): bool {.importc: " uart_is_readable_within_us".}
proc readBlocking*(uart: ptr UartInst; dst: uint8; len: csize_t) {.importc: "uart_read_blocking".}
proc putcRaw*(uart: ptr UartInst; c: cchar) {.importc: "uart_putc_raw".}
proc putc*(uart: ptr UartInst; c: cchar) {.importc: "uart_putc".}
proc puts*(uart: ptr UartInst; s: cstring) {.importc: "uart_puts".}
proc getc*(uart: ptr UartInst): cchar {.importc: "uart_getc".}
proc defaultTxWaitBlocking*(){.importC: "uart_default_tx_wait_blocking".}
  ## Wait for the default UART'S TX fifo to be drained.

{.pop.}
