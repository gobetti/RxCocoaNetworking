import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)")!
    }
}
