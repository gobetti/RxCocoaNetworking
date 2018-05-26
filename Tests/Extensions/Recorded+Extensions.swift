//
//  Recorded+Extensions.swift
//  CodeChallengeTests
//
//  Created by Marcelo Gobetti on 4/15/18.
//

import RxSwift
import RxTest

extension Recorded {
    public func map<T, U>(_ transform: (T) -> U) -> Recorded<Event<U>> where Value == Event<T> {
        switch value {
        case .next(let element):
            let event = Event.next(transform(element))
            return Recorded<Event<U>>(time: time, value: event)
        case .error(let error):
            return Recorded<Event<U>>(time: time, value: .error(error))
        case .completed:
            return Recorded<Event<U>>(time: time, value: .completed)
        }
    }
}
