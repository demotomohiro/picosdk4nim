import hidecmakelinkerpkg/libconf

initLibParams(linkLibraries = ["hardware_sync"]).config()

{.push header: "hardware/sync.h".}

proc sev*() {.importC:"__sev".}
proc wfe*() {.importC:"__wfe".}
proc wfi*() {.importC:"__wfi".}
proc dmb*() {.importC:"__dmb".}
proc dsb*() {.importC:"__dsb".}
proc isb*() {.importC:"__isb".}
proc memFenceAcquire*() {.importC:"__mem_fence_acquire".}
proc memFenceRelease*() {.importC:"__mem_fence_release".}
proc saveAndDisableInterrupts*(): uint32 {.importC:"save_and_disable_interrupts".}
proc restoreInterrupts*(status: uint32) {.importC:"restore_interrupts".}

{.pop.}
