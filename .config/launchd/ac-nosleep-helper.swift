import Foundation
import IOKit.pwr_mgt
import IOKit.ps

final class ACNoSleepHelper {
  private var assertionID: IOPMAssertionID = 0
  private var hasAssertion = false
  private let reason = "Keep Mac awake on AC power for closed-lid local services" as CFString

  func refreshAssertion() {
    if isOnACPower() {
      acquireAssertion()
    } else {
      releaseAssertion()
    }
  }

  func releaseAssertion() {
    guard hasAssertion else { return }
    IOPMAssertionRelease(assertionID)
    hasAssertion = false
    assertionID = 0
  }

  private func acquireAssertion() {
    guard !hasAssertion else { return }
    var id: IOPMAssertionID = 0
    let result = IOPMAssertionCreateWithName(
      kIOPMAssertionTypePreventSystemSleep as CFString,
      IOPMAssertionLevel(kIOPMAssertionLevelOn),
      reason,
      &id
    )
    guard result == kIOReturnSuccess else {
      fputs("ac-nosleep-helper: failed to create power assertion (\(result))\n", stderr)
      return
    }
    assertionID = id
    hasAssertion = true
  }

  private func isOnACPower() -> Bool {
    guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
          let powerSource = IOPSGetProvidingPowerSourceType(snapshot)?.takeUnretainedValue() as String?
    else {
      return false
    }
    return powerSource == (kIOPSACPowerValue as String)
  }
}

let helper = ACNoSleepHelper()
helper.refreshAssertion()

let callback: IOPowerSourceCallbackType = { context in
  guard let context else { return }
  let helper = Unmanaged<ACNoSleepHelper>.fromOpaque(context).takeUnretainedValue()
  helper.refreshAssertion()
}

if let runLoopSource = IOPSNotificationCreateRunLoopSource(
  callback,
  Unmanaged.passUnretained(helper).toOpaque()
)?.takeRetainedValue() {
  CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .defaultMode)
}

let signalSource = DispatchSource.makeSignalSource(signal: SIGTERM, queue: .main)
signal(SIGTERM, SIG_IGN)
signalSource.setEventHandler {
  helper.releaseAssertion()
  CFRunLoopStop(CFRunLoopGetCurrent())
}
signalSource.resume()

RunLoop.current.run()
