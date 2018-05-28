import Foundation

/// Defines the request characteristics to be composed with those defined by the `TargetType`.
public struct Task {
    /// The HTTP method used in the request.
    let method: HTTPMethod
    
    /// The request's body, if any.
    let body: Data?
    
    /// The request's encoded parameters, if any.
    let parameters: [String: String]?
    
    public init(method: HTTPMethod = .get, body: Data? = nil, parameters: [String: String]? = nil) {
        self.method = method
        self.body = body
        self.parameters = parameters
    }
    
    public init(method: HTTPMethod = .get, dictionaryBody: [String: Any], parameters: [String: String]? = nil) {
        let body = try? JSONSerialization.data(withJSONObject: dictionaryBody, options: [])
        self.init(method: method, body: body, parameters: parameters)
    }
}
