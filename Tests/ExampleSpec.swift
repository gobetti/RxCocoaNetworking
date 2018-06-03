import Foundation
import Quick
import Nimble
import RxSwift
import XCTest
@testable import RxCocoaNetworking

final class ExampleSpec: QuickSpec {
    override func spec() {
        describe("MockAPI") {
            typealias SUT = MockAPI
            let provider = Provider<SUT>()
            
            var disposeBag: DisposeBag!
            var response: SingleEvent<Data>?
            beforeEach {
                response = nil
                disposeBag = DisposeBag()
            }
            
            func bindRequest(_ target: SUT) {
                provider.request(target)
                    .materialize()
                    .subscribe(onSuccess: { response = $0 },
                               onError: { XCTFail($0.localizedDescription) })
                    .disposed(by: disposeBag)
            }
            
            describe("delete movie rating") {
                func target(movieID: String) -> SUT {
                    return SUT.deleteRating(movieID: movieID)
                }
                
                it("succeeds for valid movie ID") {
                    bindRequest(target(movieID: "123"))
                    expect(response?.element).toEventuallyNot(beNil())
                }
                
                it("fails for invalid movie ID") {
                    bindRequest(target(movieID: "abc"))
                    expect(response?.error).toEventuallyNot(beNil())
                }
            }
            
            describe("rate movie") {
                func target(movieID: String) -> SUT {
                    return SUT.rate(movieID: movieID, rating: 8.5)
                }
                
                it("succeeds for valid movie ID") {
                    bindRequest(target(movieID: "123"))
                    expect(response?.element).toEventuallyNot(beNil())
                }
                
                it("fails for invalid movie ID") {
                    bindRequest(target(movieID: "abc"))
                    expect(response?.error).toEventuallyNot(beNil())
                }
            }
            
            describe("get movie reviews") {
                func target(movieID: String, page: Int) -> SUT {
                    return SUT.reviews(movieID: movieID, page: page)
                }
                
                it("succeeds for valid movie ID and page") {
                    bindRequest(target(movieID: "123", page: 1))
                    expect(response?.element).toEventuallyNot(beNil())
                }
                
                it("fails for invalid movie ID") {
                    bindRequest(target(movieID: "abc", page: 1))
                    expect(response?.error).toEventuallyNot(beNil())
                }
                
                it("fails for invalid page") {
                    bindRequest(target(movieID: "123", page: -1))
                    expect(response?.error).toEventuallyNot(beNil())
                }
            }
        }
    }
}
