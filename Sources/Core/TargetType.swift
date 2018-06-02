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

/// https://github.com/Moya/Moya/blob/master/Sources/Moya/Task.swift
public enum Task {
    /// A request sent with encoded parameters.
    case requestParameters(parameters: [String: String])
    
    /// A request with no additional data.
    case requestPlain
}

/// https://github.com/Moya/Moya/blob/master/Sources/Moya/TargetType.swift
/// Defines the contract for API models that are able to provide stubs by themselves.
public protocol TargetType {
    /// The target's base `URL`.
    var baseURL: URL { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    /// Provides stub data for use in testing.
    var sampleData: Data { get }
    
    /// The type of HTTP task to be performed.
    var task: Task { get }
    
    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}
