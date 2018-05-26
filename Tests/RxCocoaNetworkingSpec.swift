//
//  RxCocoaNetworkingSpec.swift
//  RxCocoaNetworking
//
//  Created by Marcelo Gobetti on 04/10/16.
//  Copyright © 2017 gobetti. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import RxCocoaNetworking

final class RxCocoaNetworkingSpec: QuickSpec {
    override func spec() {
        describe("URLRequest") {
            var request: URLRequest!
            beforeEach {
                request = URLRequest(url: URL(string: "www.test.com/test")!)
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
                            .to(equal("www.test.com/test?param1=value1&param2=value2"))
                    }
                }
                
                context("and they are empty") {
                    beforeEach { parameters = [:] }
                    
                    it("has the URL untouched") {
                        expect(parameterizedRequest.url!.absoluteString)
                            .to(equal(request.url!.absoluteString))
                    }
                }
                
                context("and a key is invalid") {
                    beforeEach {
                        let invalidKey = String(bytes: [0xD8, 0x00] as [UInt8], encoding: .utf16BigEndian)!
                        parameters = ["param1": "value1", "\(invalidKey)": "value2"]
                    }
                    
                    it("has valid URL without the invalid parameters") {
                        expect(parameterizedRequest.url!.absoluteString)
                            .to(equal("www.test.com/test?param1=value1"))
                    }
                }
                
                context("and a value is invalid") {
                    beforeEach {
                        let invalidValue = String(bytes: [0xD8, 0x00] as [UInt8], encoding: .utf16BigEndian)!
                        parameters = ["param1": "value1", "param2": "\(invalidValue)"]
                    }
                    
                    it("has valid URL without the invalid parameters") {
                        expect(parameterizedRequest.url!.absoluteString)
                            .to(equal("www.test.com/test?param1=value1"))
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
