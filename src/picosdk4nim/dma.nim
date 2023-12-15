import hidecmakelinkerpkg/libconf

initLibParams(linkLibraries = ["hardware_dma"]).config()

{.push header: "hardware/dma.h".}

type
  DmaChannelConfig* {.byref, importc: "dma_channel_config".} = object

  DmaChannelTransferSize* {.importc: "enum dma_channel_transfer_size".} = enum
    ## Enumeration of available DMA channel transfer sizes.
    ## Names indicate the number of bits.
    SIZE8, SIZE16, SIZE32

  DmaChannel* = distinct cuint

proc claim*(channel: DmaChannel) {.importC: "dma_channel_claim".}
proc dmaClaimMask*(channelMask: uint32) {.importC: "dma_claim_mask".}
proc unclaim*(channel: DmaChannel) {.importC: "dma_channel_unclaim".}
proc dmaUnclaimMask*(channel_mask: uint32) {.importC: "dma_unclaim_mask".}
proc dmaClaimUnusedChannel*(required: bool): DmaChannel {.importC: "dma_claim_unused_channel".}
proc isClaimed*(channel: DmaChannel): bool {.importC: "dma_channel_is_claimed".}
proc setConfig*(channel: DmaChannel; config: DmaChannelConfig; trigger: bool) {.importC: "dma_channel_set_config".}
proc setReadAddr*(channel: DmaChannel; readAddr: pointer; trigger: bool) {.importC: "dma_channel_set_read_addr".}
proc setWriteAddr*(channel: DmaChannel; writeAddr: pointer; trigger: bool) {.importC: "dma_channel_set_write_addr".}
proc setTransCount*(channel: DmaChannel; transCount: uint32, trigger: bool) {.importC: "dma_channel_set_trans_count".}
proc configure*(channel: DmaChannel; config: DmaChannelConfig; writeAddr: pointer; readAddr: pointer; transferCount: cuint; trigger: bool) {.importC: "dma_channel_configure".}
proc transferFromBufferNow*(channel: DmaChannel; readAddr: pointer; transferCount: uint32) {.importC: "dma_channel_transfer_from_buffer_now".}
proc transferToBufferNow*(channel: DmaChannel; writeAddr: pointer; transferCount: uint32) {.importC: "dma_channel_transfer_to_buffer_now".}
proc dmaStartChannelMask*(chan_mask: uint32) {.importC: "dma_start_channel_mask".}
proc start*(channel: DmaChannel) {.importC: "dma_channel_start".}
proc abort*(channel: DmaChannel) {.importC: "dma_channel_abort".}
proc setIrq0Enabled*(channel: DmaChannel; enabled: bool) {.importC: "dma_channel_set_irq0_enabled".}
proc dmaSetIrq0ChannelMaskEnabled*(channelMask: uint32, enabled: bool) {.importC: "dma_set_irq0_channel_mask_enabled".}
proc setIrq1Enabled*(channel: DmaChannel; enabled: bool) {.importC: "dma_channel_set_irq1_enabled".}
proc dmaSetIrq1ChannelMaskEnabled*(channelMask: uint32, enabled: bool) {.importC: "dma_set_irq1_channel_mask_enabled".}
proc dmaIrqnSetChannelEnabled*(irqIndex: cuint; channel: DmaChannel; enabled: bool) {.importC: "dma_irqn_set_channel_enabled".}
proc dmaIrqnSetChannelMaskEnabled*(irqIndex: cuint; channelMask: uint32, enabled: bool) {.importC: "dma_irqn_set_channel_mask_enabled".}
proc getIrq0Status*(channel: DmaChannel): bool {.importC: "dma_channel_get_irq0_status".}
proc getIrq1Status*(channel: DmaChannel): bool {.importC: "dma_channel_get_irq1_status".}
proc dmaIrqnGetChannelStatus*(irqIndex: cuint; channel: DmaChannel): bool {.importC: "dma_irqn_get_channel_status".}
proc acknowledgeIrq0*(channel: DmaChannel) {.importC: "dma_channel_acknowledge_irq0".}
proc acknowledgeIrq1*(channel: DmaChannel) {.importC: "dma_channel_acknowledge_irq1".}
proc dmaIrqnAcknowledgeChannel*(irqIndex: cuint; channel: DmaChannel) {.importC: "dma_irqn_acknowledge_channel".}
proc isBusy*(channel: DmaChannel): bool {.importC: "dma_channel_is_busy".}
proc waitForFinishBlocking*(channel: DmaChannel) {.importC: "dma_channel_wait_for_finish_blocking".}
proc snifferEnable*(channel: DmaChannel; mode: cuint; forceChannelEnable: bool) {.importC: "dma_sniffer_enable".}
proc dmaSnifferSetByteSwapEnabled*(swap: bool) {.importC: "dma_sniffer_set_byte_swap_enabled".}
proc dmaSnifferSetOutputInvertEnabled*(invert: bool) {.importC: "dma_sniffer_set_output_invert_enabled".}
proc dmaSnifferSetOutputReverseEnabled*(reverse: bool) {.importC: "dma_sniffer_set_output_reverse_enabled".}
proc dmaSnifferDisable*() {.importC: "dma_sniffer_disable".}
proc dmaSnifferSetDataAccumulator*(seedValue: uint32) {.importC: "dma_sniffer_set_data_accumulator".}
proc dmaSnifferGetDataAccumulator*(): uint32 {.importC: "dma_sniffer_get_data_accumulator".}
proc dmaTimerClaim*(timer: cuint) {.importC: "dma_timer_claim".}
proc dmaTimerUnclaim*(timer: cuint) {.importC: "dma_timer_unclaim".}
proc dmaClaimUnusedTimer*(required: bool): cint {.importC: "dma_claim_unused_timer".}
proc dmaTimerIsClaimed*(timer: cuint): bool {.importC: "dma_timer_is_claimed".}
proc dmaTimerSetFraction*(timer: cuint; numerator, denominator: uint16) {.importC: "dma_timer_set_fraction".}
proc dmaGetTimerDreq*(timer_num: cuint): cuint {.importC: "dma_get_timer_dreq".}
proc cleanup*(channel: DmaChannel) {.importC: "dma_channel_cleanup".}
proc setReadIncrement*(c: DmaChannelConfig; incr: bool) {.importC: "channel_config_set_read_increment".}
proc setWriteIncrement*(c: DmaChannelConfig; incr: bool) {.importC: "channel_config_set_write_increment".}
proc setDreq*(c: DmaChannelConfig; dreq: cuint) {.importC: "channel_config_set_dreq".}
proc setChainTo*(c: DmaChannelConfig; chainTo: DmaChannel) {.importC: "channel_config_set_chain_to".}
proc setTransferDataSize*(c: DmaChannelConfig; size: DmaChannelTransferSize) {.importC: "channel_config_set_transfer_data_size".}
proc setRing*(c: DmaChannelConfig; write: bool; sizeBits: cuint) {.importC: "channel_config_set_ring".}
proc setBswap*(c: DmaChannelConfig; bswap: bool) {.importC: "channel_config_set_bswap".}
proc setIrqQuiet*(c: DmaChannelConfig; irqQuiet: bool) {.importC: "channel_config_set_irq_quiet".}
proc setHighPriority*(c: DmaChannelConfig; highPriority: bool) {.importC: "channel_config_set_high_priority".}
proc setEnable*(c: DmaChannelConfig; enable: bool) {.importC: "channel_config_set_enable".}
proc setSniffEnable*(c: DmaChannelConfig; sniffEnable: bool) {.importC: "channel_config_set_sniff_enable".}
proc getDefaultConfig*(channel: DmaChannel): DmaChannelConfig {.importC: "dma_channel_get_default_config".}
proc getChannelConfig*(channel: DmaChannel): DmaChannelConfig {.importC: "dma_get_channel_config".}
proc getCtrlValue*(config: DmaChannelConfig): uint32 {.importC: "channel_config_get_ctrl_value".}
