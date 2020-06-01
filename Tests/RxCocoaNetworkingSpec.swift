import Foundation
import Quick
import Nimble
@testable import RxCocoaNetworking

final class RxCocoaNetworkingSpec: QuickSpec {
    override func spec() {
        describe("URLRequest") {
            var request: URLRequest!
            beforeEach {
                request = URLRequest(url: "www.test.com/test")
            }
            
            describe("when parameters are added") {
                var parameters: [String : String]!
                var parameterizedRequest: URLRequest {
                    return request.addingParameters(parameters)
                }
                
                context("and they are valid") {
                    beforeEach { parameters = ["param1": "value1", "param2": "value2"] }
                    
                    it("has valid URL with parameters") {
                        expect(parameterizedRequest.url!.absoluteString)
                            .to(satisfyAnyOf(equal("www.test.com/test?param1=value1&param2=value2"),
                                             equal("www.test.com/test?param2=value2&param1=value1")))
                    }
                }
                
                context("and they are empty") {
                    beforeEach { parameters = [:] }
                    
                    it("has the URL untouched") {
                        expect(parameterizedRequest.url!.absoluteString)
                            .to(equal(request.url!.absoluteString))
                    }
                }
                
                context("and the original URL is nil") {
                    beforeEach {
                        request.url = nil
                        parameters = ["param1": "value1", "param2": "value2"]
                    }
                    
                    it("is untouched") {
                        expect(parameterizedRequest)
                            .to(equal(request))
                    }
                }
            }
        }
    }
}
