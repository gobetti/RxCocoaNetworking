import Foundation
import RxCocoaNetworking

enum ExampleAPI {
    case deleteRating(movieID: String)
    case rate(movieID: String, rating: Float)
    case reviews(movieID: String, page: Int)
}

extension ExampleAPI: ProductionTargetType {
    var baseURL: URL { return URL(string: "http://localhost:8080")! }
    
    var path: String {
        switch self {
        case .deleteRating(let movieID),
             .rate(let movieID, _):
            return "/movie/\(movieID)/rating"
        case .reviews(let movieID, _):
            return "/movie/\(movieID)/reviews"
        }
    }
    
    var task: Task {
        let defaultParameters = ["api_key" : "1234567890"]
        
        switch self {
        case .deleteRating:
            return Task(method: .delete, parameters: defaultParameters)
        case .rate(_, let rating):
            return Task(method: .post,
                        dictionaryBody: ["value": rating],
                        parameters: defaultParameters)
        case .reviews(_, let page):
            let parameters = defaultParameters.merging(["page": "\(page)"]) { (_, new) in new }
            return Task(parameters: parameters)
        }
    }
    
    var headers: [String : String]? { return nil }
}
