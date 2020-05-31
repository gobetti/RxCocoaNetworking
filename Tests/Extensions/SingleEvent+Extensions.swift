/*
 Original work Copyright (c) 2015-present Krunoslav Zaher
 Modified work Copyright (c) 2018-present Marcelo Gobetti
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 */

import RxSwift

/// Based off https://github.com/ReactiveX/RxSwift/blob/master/RxSwift/Observables/Materialize.swift
extension PrimitiveSequenceType where Trait == SingleTrait {
    public func materialize() -> Single<SingleEvent<Element>> {
        return self
            .map { .success($0) }
            .catchError { .just(SingleEvent.error($0)) }
    }
}

/// Adapted from https://github.com/ReactiveX/RxSwift/blob/master/RxSwift/Event.swift
extension SingleEvent {
    public var element: Element? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
    
    public var error: Swift.Error? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
}
