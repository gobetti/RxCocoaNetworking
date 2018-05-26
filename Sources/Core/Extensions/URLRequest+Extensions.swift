import Foundation

extension URLRequest {
    func addingParameters(_ parameters: [String: String]) -> URLRequest {
        guard !parameters.isEmpty else { return self }
        guard let url = url else { return self }
        
        let query = parameters.compactMap { key, value in
            guard let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    return nil
            }
            return "\(escapedKey)=\(escapedValue)"
            }.joined(separator: "&")
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return self }
        
        urlComponents.percentEncodedQuery = query
        var request = self
        request.url = urlComponents.url
        return request
    }
}
