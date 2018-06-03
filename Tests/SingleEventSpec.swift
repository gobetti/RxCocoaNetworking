import Foundation
import Quick
import Nimble
import RxSwift
@testable import RxCocoaNetworking

final class SingleEventSpec: QuickSpec {
    override func spec() {
        describe("SingleEvent") {
            var singleEvent: SingleEvent<String>!
            
            context("when successful") {
                beforeEach { singleEvent = .success("a") }
                
                it("has non-nil element") {
                    expect(singleEvent.element).toNot(beNil())
                }
                
                it("has nil error") {
                    expect(singleEvent.error).to(beNil())
                }
            }
            
            context("when failed") {
                beforeEach { singleEvent = .error(TestError.someError) }
                
                it("has nil element") {
                    expect(singleEvent.element).to(beNil())
                }
                
                it("has non-nil error") {
                    expect(singleEvent.error).toNot(beNil())
                }
            }
        }
    }
}
