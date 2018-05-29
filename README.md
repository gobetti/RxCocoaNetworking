# RxCocoaNetworking


[![Build Status](https://travis-ci.org/gobetti/RxCocoaNetworking.svg)](https://travis-ci.org/gobetti/RxCocoaNetworking) [![codecov.io](http://codecov.io/github/gobetti/RxCocoaNetworking/coverage.svg?branch=master)](http://codecov.io/github/gobetti/RxCocoaNetworking?branch=master)

[![CocoaPods compatible](https://img.shields.io/cocoapods/v/RxCocoaNetworking.svg)](https://cocoapods.org/pods/RxCocoaNetworking)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

A `Moya`-inspired, `RxTest`-testable networking framework built on top of `RxCocoa`.

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

While [Moya](https://github.com/Moya/Moya) is built on top of [Alamofire](https://github.com/Alamofire/Alamofire) and provides an Rx extension with `Observable` signatures, **RxCocoaNetworking** is built on top of [RxCocoa](https://github.com/ReactiveX/RxSwift), which already provides extensions to `NSURLSession` with `Observable` signatures. If you love `Moya` like I do because of how organized it makes your network layer, and how easy and readable unit testing becomes; and if your project already depends on `RxCocoa`, then **RxCocoaNetworking** is for you.

Thanks to the network request handling already embedded in `RxCocoa`, to Swift 4.1's conditional conformance (see [ReactiveURLSessionProtocol](https://github.com/gobetti/RxCocoaNetworking/blob/master/Sources/Core/ReactiveURLSessionProtocol.swift)) and heavily inspired by `Moya`'s architecture, **RxCocoaNetworking** provides you the same power and unit testing flexibility that `Moya` does, including full support to `TestScheduler` in a very lightweight framework.

The motivation to write a new framework came from the fact that Moya's `MoyaProvider` implements the `delayed` `StubBehavior` with a real-time unit delay, preventing the usage of `RxTest` to assert this functionality. Being able to remove the dependency to `Alamofire` came next.

## Requirements

- iOS 9.0+ / Mac OS X 10.11+ / tvOS 10.0+ / watchOS 3.0+
- Xcode 9.3+
- Swift 4.1

## Installation

### Dependency Managers
<details>
  <summary><strong>CocoaPods</strong></summary>

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate RxCocoaNetworking into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'RxCocoaNetworking', '~> 0.0.1'
```

Then, run the following command:

```bash
$ pod install
```

</details>

<details>
  <summary><strong>Carthage</strong></summary>

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate RxCocoaNetworking into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "gobetti/RxCocoaNetworking" ~> 0.0.1
```

</details>

<details>
  <summary><strong>Swift Package Manager</strong></summary>

To use RxCocoaNetworking as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

```swift
// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "HelloRxCocoaNetworking",
    dependencies: [
        .package(url: "https://github.com/gobetti/RxCocoaNetworking.git", .upToNextMajor(from: "0.0.1"))
    ],
    targets: [
        .target(name: "HelloRxCocoaNetworking", dependencies: ["RxCocoaNetworking"])
    ]
)
```
</details>

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate RxCocoaNetworking into your project manually.

<details>
  <summary><strong>Git Submodules</strong></summary><p>

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add RxCocoaNetworking as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/gobetti/RxCocoaNetworking.git
$ git submodule update --init --recursive
```

- Open the new `RxCocoaNetworking` folder, and drag the `RxCocoaNetworking.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `RxCocoaNetworking.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `RxCocoaNetworking.xcodeproj` folders each with two different versions of the `RxCocoaNetworking.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from.

- Select the `RxCocoaNetworking.framework`.

- And that's it!

> The `RxCocoaNetworking.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

</p></details>

<details>
  <summary><strong>Embedded Binaries</strong></summary><p>

- Download the latest release from https://github.com/gobetti/RxCocoaNetworking/releases
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- Add the downloaded `RxCocoaNetworking.framework`.
- And that's it!

</p></details>

## Usage

## Contributing

Issues and pull requests are welcome!

## Author

Marcelo Gobetti [@mwgobetti](https://twitter.com/mwgobetti)

## License

RxCocoaNetworking is released under the MIT license. See [LICENSE](https://github.com/gobetti/RxCocoaNetworking/blob/master/LICENSE) for details.
