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

/// The different types of stub, where `default` falls back to the `TargetType`'s `sampleData`.
public enum Stub {
  case `default`
  case success(Data)
  case error(Error)
}

/// https://github.com/Moya/Moya/blob/master/Sources/Moya/MoyaProvider.swift
/// The different stubbing modes.
public enum StubBehavior {
  /// Stubs and delays the response for a specified amount of time.
  case delayed(time: TimeInterval, stub: Stub)
  
  /// Stubs the response without delaying it.
  case immediate(stub: Stub)
  
  /// Does not stub the response.
  case never
}
