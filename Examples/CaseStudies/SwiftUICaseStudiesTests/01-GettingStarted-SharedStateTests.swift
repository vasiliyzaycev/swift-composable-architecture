import Combine
import ComposableArchitecture
import XCTest

@testable import SwiftUICaseStudies

class SharedStateTests: XCTestCase {
  func testTabRestoredOnReset() {
    let store = _TestStore(
      initialState: .init(),
      reducer: SharedState()
    )

    store.send(.selectTab(.profile)) {
      $0.currentTab = .profile
      $0.profile = .init(
        currentTab: .profile, count: 0, maxCount: 0, minCount: 0, numberOfCounts: 0)
    }
    store.send(.profile(.resetCounterButtonTapped)) {
      $0.currentTab = .counter
      $0.profile = .init(
        currentTab: .counter, count: 0, maxCount: 0, minCount: 0, numberOfCounts: 0)
    }
  }

  func testTabSelection() {
    let store = _TestStore(
      initialState: .init(),
      reducer: SharedState()
    )

    store.send(.selectTab(.profile)) {
      $0.currentTab = .profile
      $0.profile = .init(
        currentTab: .profile, count: 0, maxCount: 0, minCount: 0, numberOfCounts: 0)
    }
    store.send(.selectTab(.counter)) {
      $0.currentTab = .counter
      $0.profile = .init(
        currentTab: .counter, count: 0, maxCount: 0, minCount: 0, numberOfCounts: 0)
    }
  }

  func testSharedCounts() {
    let store = _TestStore(
      initialState: .init(),
      reducer: SharedState()
    )

    store.send(.counter(.incrementButtonTapped)) {
      $0.counter.count = 1
      $0.counter.maxCount = 1
      $0.counter.numberOfCounts = 1
    }
    store.send(.counter(.decrementButtonTapped)) {
      $0.counter.count = 0
      $0.counter.numberOfCounts = 2
    }
    store.send(.counter(.decrementButtonTapped)) {
      $0.counter.count = -1
      $0.counter.minCount = -1
      $0.counter.numberOfCounts = 3
    }
  }

  func testIsPrimeWhenPrime() {
    let store = _TestStore(
      initialState: .init(alert: nil, count: 3, maxCount: 0, minCount: 0, numberOfCounts: 0),
      reducer: SharedState.Counter()
    )

    store.send(.isPrimeButtonTapped) {
      $0.alert = .init(
        title: .init("👍 The number \($0.count) is prime!")
      )
    }
    store.send(.alertDismissed) {
      $0.alert = nil
    }
  }

  func testIsPrimeWhenNotPrime() {
    let store = _TestStore(
      initialState: .init(alert: nil, count: 6, maxCount: 0, minCount: 0, numberOfCounts: 0),
      reducer: SharedState.Counter()
    )

    store.send(.isPrimeButtonTapped) {
      $0.alert = .init(
        title: .init("👎 The number \($0.count) is not prime :(")
      )
    }
    store.send(.alertDismissed) {
      $0.alert = nil
    }
  }
}
