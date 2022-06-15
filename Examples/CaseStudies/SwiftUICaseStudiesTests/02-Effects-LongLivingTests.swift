import Combine
import ComposableArchitecture
import XCTest

@testable import SwiftUICaseStudies

class LongLivingEffectsTests: XCTestCase {
  @MainActor
  func testReducer() async {
    let (screenshots, takeScreenshot) = AsyncStream<Void>.streamWithContinuation()

    let store = _TestStore(
      initialState: .init(),
      reducer: LongLivingEffects()
        .dependency(\.screenshots) { screenshots }
    )

    let task = store.send(.task)

    // Simulate a screenshot being taken
    takeScreenshot.yield()

    await store.receive(.userDidTakeScreenshotNotification) {
      $0.screenshotCount = 1
    }

    // Simulate screen going away
    await task.cancel()

    // Simulate a screenshot being taken to show no effects are executed.
    takeScreenshot.yield()
  }
}
