//
//  MockAPI.swift
//  RxCocoaNetworking-Example-macOS
//
//  Created by Marcelo Gobetti on 6/3/18.
//  Copyright © 2018 gobetti. All rights reserved.
//

import Foundation
import RxCocoaNetworking

enum MockAPI {
    case deleteRating(movieID: String)
    case rate(movieID: String, rating: Float)
    case reviews(movieID: String, page: Int)
}

extension MockAPI: TargetType {
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
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
}
