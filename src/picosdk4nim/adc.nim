import gpio
import hidecmakelinkerpkg/libconf

initLibParams(linkLibraries = @["hardware_adc"]).config()

type AdcInput* {.size: sizeof(cuint).} = enum
  ## Aliases for selectInput() procedure
  ## ADC input. 0...3 are GPIOs 26...29 respectively. Input 4 is the onboard temperature sensor.
  Adc26 = 0, Adc27 = 1, Adc28 = 2, Adc29 = 3, AdcTemp = 4

const ThreePointThreeConv* = 3.3f / (1 shl 12)
  ## Useful for reading inputs from a 3.3v source

{.push header:"hardware/adc.h".}
proc adcInit*{.importC:"adc_init".}
  ## Initialise the ADC hardware

proc adcRead*: uint16 {.importC: "adc_read".}
 ## Performs a single ADC conversion, waits for the result, and then returns it.
 ## 
 ## **Returns:** Result of the conversion.

proc initAdc*(gpio: Gpio){.importC: "adc_gpio_init".}
  ## Prepare a GPIO for use with ADC, by disabling all digital functions.
  ## 
  ## **Parameters:**
  ## 
  ## =========  ====== 
  ## **gpio**    The GPIO number to use. Allowable GPIO numbers are 26 to 29 inclusive.
  ## =========  ====== 

proc selectInput*(input: AdcInput){.importc: "adc_select_input".}
  ## ADC input select.
  ## 
  ## **Parameters:**
  ## 
  ## =========  ====== 
  ## **input**   ADC input. 0...3 are GPIOs 26...29 respectively. Input 4 is the onboard temperature sensor.
  ## =========  ====== 

proc enableTempSensor*(enable: bool){.importc: "adc_set_temp_sensor_enabled".}
  ## Enable the onboard temperature sensor.
  ## 
  ## **Parameters:**
  ## 
  ## ===========  ====== 
  ## **enable**    Set true to power on the onboard temperature sensor, false to power off.
  ## ===========  ====== 

proc adcRun*(run: bool) {.importC: "adc_run".}
  ## Enable or disable free-running sampling mode.
  ##
  ## **Parameters:**
  ##
  ## ========  ======
  ## **run**    false to disable, true to enable free running conversion mode.
  ## ========  ======

proc adcFifoSetup*(en, dreqEn: bool; dreqThresh: uint16; errInFifo, byteShift: bool) {.importC: "adc_fifo_setup".}
  ## Setup the ADC FIFO.
  ##
  ## On RP2040 the FIFO is 4 samples long.
  ## On RP2350 the FIFO is 8 samples long.
  ##
  ## If a conversion is completed and the FIFO is full, the result is dropped.
  ##
  ## **Parameters:**
  ##
  ## ===============  ======
  ## **en**            Enables write each conversion result to the FIFO
  ## **dreqEn**	       Enable DMA requests when FIFO contains data
  ## **dreqThresh**	   Threshold for DMA requests/FIFO IRQ if enabled.
  ## **errInFifo**	   If enabled, bit 15 of the FIFO contains error flag for each sample
  ## **byteShift**	   Shift FIFO contents to be one byte in size (for byte DMA) - enables DMA to byte buffers.
  ## ===============  ======

proc adcFifoGetBlocking*: uint16 {.importC: "adc_fifo_get_blocking".}
  ## Wait for the ADC FIFO to have data and return the data.

proc adcFifoDrain* {.importC: "adc_fifo_drain".}
  ## Will wait for any conversion to complete then drain the FIFO, discarding any results.

{.pop.}
