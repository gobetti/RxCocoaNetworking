import Foundation

extension URLRequest {
    func addingParameters(_ parameters: [String: String]) -> URLRequest {
        guard !parameters.isEmpty else { return self }
        guard let url = url else { return self }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return self }
        
        urlComponents.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        var request = self
        request.url = urlComponents.url
        return request
    }
}
