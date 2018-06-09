/*
 Original work Copyright (c) 2014-present Artsy, Ash Furrow
 Modified work Copyright (c) 2018-present Marcelo Gobetti
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 */

import Foundation
import RxSwift

public enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case trace = "TRACE"
}

/// https://github.com/Moya/Moya/blob/master/Sources/Moya/TargetType.swift
/// Defines the contract for API structures.
public protocol ProductionTargetType {
    associatedtype TargetStub = ProductionStub
    
    /// The target's base `URL`.
    var baseURL: URL { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP task to be performed.
    var task: Task { get }
    
    /// The headers to be used in the request.
    /// Essentially this should be part of `Task`, however headers are often reused by a `Target`'s endpoints.
    var headers: [String: String]? { get }
    
    /// Factory method that converts a `TargetStub` into an immediate `Data` response.
    func makeResponse(from stub: TargetStub) -> Observable<Data>
}

/// Defines the contract for API structures that provide stubs for themselves.
/// It is recommended to implement this protocol separately in the Tests target.
public protocol TargetType: ProductionTargetType where TargetStub == Stub {
    /// Provides stub data for use in testing.
    var sampleData: Data { get }
}

// MARK: - Default implementations
public extension ProductionTargetType where TargetStub == ProductionStub {
    func makeResponse(from stub: TargetStub) -> Observable<Data> {
        switch stub {
        case .success(let data):
            return .just(data)
        case .error(let error):
            return .error(error)
        }
    }
}

public extension TargetType where TargetStub == Stub {
    func makeResponse(from stub: TargetStub) -> Observable<Data> {
        switch stub {
        case .default:
            return .just(sampleData)
        case .success(let data):
            return .just(data)
        case .error(let error):
            return .error(error)
        }
    }
}
