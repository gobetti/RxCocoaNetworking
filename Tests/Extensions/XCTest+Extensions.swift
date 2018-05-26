//
//  XCTest+Extensions.swift
//  CodeChallengeTests
//
//  Created by Marcelo Gobetti on 4/15/18.
//

import RxSwift
import RxTest
import XCTest

public func XCTAssertThrowsError<T>(_ recordedEvents: [Recorded<Event<T>>]) {
    XCTAssertTrue(recordedEvents.contains(where: { $0.value.error != nil }))
}
