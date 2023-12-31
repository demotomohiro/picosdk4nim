import hidecmakelinkerpkg/libconf

initLibParams(linkLibraries = ["hardware_irq"]).config()

type
  Irq* = distinct cuint

proc `==`*(a, b: Irq): bool {.borrow.}
proc `$`*(a: Irq): string {.borrow.}

const
  TIMER_IRQ_0* = 0.Irq
  TIMER_IRQ_1* = 1.Irq
  TIMER_IRQ_2* = 2.Irq
  TIMER_IRQ_3* = 3.Irq
  PWM_IRQ_WRAP* = 4.Irq
  USBCTRL_IRQ* = 5.Irq
  XIP_IRQ* = 6.Irq
  PIO0_IRQ_0* = 7.Irq
  PIO0_IRQ_1* = 8.Irq
  PIO1_IRQ_0* = 9.Irq
  PIO1_IRQ_1* = 10.Irq
  DMA_IRQ_0* = 11.Irq
  DMA_IRQ_1* = 12.Irq
  IO_IRQ_BANK0* = 13.Irq
  IO_IRQ_QSPI* = 14.Irq
  SIO_IRQ_PROC0* = 15.Irq
  SIO_IRQ_PROC1* = 16.Irq
  CLOCKS_IRQ* = 17.Irq
  SPI0_IRQ* = 18.Irq
  SPI1_IRQ* = 19.Irq
  UART0_IRQ* = 20.Irq
  UART1_IRQ* = 21.Irq
  ADC_IRQ_FIFO* = 22.Irq
  I2C0_IRQ* = 23.Irq
  I2C1_IRQ* = 24.Irq
  RTC_IRQ* = 25.Irq

{.push header: "hardware/irq.h".}

type
  IrqHandler* {.importC: "irq_handler_t".} = proc(){.noconv.}

proc setEnabled*(num: Irq; enabled: bool) {.importC: "irq_set_enabled".}
proc isEnabled*(num: Irq): bool {.importC: "irq_is_enabled".}
proc setExclusiveHandler*(num: Irq; handler: IrqHandler) {.importC: "irq_set_exclusive_handler".}
proc clear*(num: Irq) {.importC: "irq_clear".}

{.pop.}
