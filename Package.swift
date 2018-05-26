//
//  RxCocoaNetworking.swift
//  RxCocoaNetworking
//
//  Created by Marcelo Gobetti on 23/10/15.
//  Copyright © 2017 gobetti. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "RxCocoaNetworking",
    dependencies: [.Package(url: "https://github.com/ReactiveX/RxSwift.git", majorVersion: 4)],
    exclude: ["Tests"]
)
