import Foundation
import Quick
import Nimble
import RxCocoa
import RxSwift
import XCTest
@testable import RxCocoaNetworking

final class ExampleSpec: QuickSpec {
    override func spec() {
        describe("MockAPI") {
            var disposeBag: DisposeBag!
            
            typealias SUT = MockAPI
            let provider = Provider<SUT>()
            let stubbedProvider = Provider<SUT>(stubBehavior: .immediate(stub: .default))
            
            typealias Response = SingleEvent<Data>
            var response: BehaviorRelay<Response?>!
            var stubbedResponse: BehaviorRelay<Response?>!
            beforeEach {
                response = BehaviorRelay<Response?>(value: nil)
                stubbedResponse = BehaviorRelay<Response?>(value: nil)
                disposeBag = DisposeBag()
            }
            
            func bindRequest(_ target: SUT, provider: Provider<SUT>, response: BehaviorRelay<Response?>) {
                provider.request(target)
                    .materialize()
                    .asObservable()
                    .bind(to: response)
                    .disposed(by: disposeBag)
            }
            
            func bindRequest(_ target: SUT) {
                bindRequest(target, provider: provider, response: response)
            }
            
            func bindStubbedRequest(_ target: SUT) {
                bindRequest(target, provider: stubbedProvider, response: stubbedResponse)
            }
            
            describe("delete movie rating") {
                func target(movieID: String) -> SUT {
                    return SUT.deleteRating(movieID: movieID)
                }
                
                it("succeeds for sample stub") {
                    bindStubbedRequest(target(movieID: "123"))
                    expect(stubbedResponse.value?.element).toEventuallyNot(beNil())
                }
                
                it("succeeds for valid movie ID") {
                    bindRequest(target(movieID: "123"))
                    expect(response.value?.element).toEventuallyNot(beNil())
                }
                
                it("fails for invalid movie ID") {
                    bindRequest(target(movieID: "abc"))
                    expect(response.value?.error).toEventuallyNot(beNil())
                }
            }
            
            describe("rate movie") {
                func target(movieID: String) -> SUT {
                    return SUT.rate(movieID: movieID, rating: 8.5)
                }
                
                it("succeeds for sample stub") {
                    bindStubbedRequest(target(movieID: "123"))
                    expect(stubbedResponse.value?.element).toEventuallyNot(beNil())
                }
                
                it("succeeds for valid movie ID") {
                    bindRequest(target(movieID: "123"))
                    expect(response.value?.element).toEventuallyNot(beNil())
                }
                
                it("fails for invalid movie ID") {
                    bindRequest(target(movieID: "abc"))
                    expect(response.value?.error).toEventuallyNot(beNil())
                }
            }
            
            describe("get movie reviews") {
                func target(movieID: String, page: Int) -> SUT {
                    return SUT.reviews(movieID: movieID, page: page)
                }
                
                it("succeeds for sample stub") {
                    bindStubbedRequest(target(movieID: "123", page: 1))
                    expect(stubbedResponse.value?.element).toEventuallyNot(beNil())
                }
                
                it("succeeds for valid movie ID and page") {
                    bindRequest(target(movieID: "123", page: 1))
                    expect(response.value?.element).toEventuallyNot(beNil())
                }
                
                it("fails for invalid movie ID") {
                    bindRequest(target(movieID: "abc", page: 1))
                    expect(response.value?.error).toEventuallyNot(beNil())
                }
                
                it("fails for invalid page") {
                    bindRequest(target(movieID: "123", page: -1))
                    expect(response.value?.error).toEventuallyNot(beNil())
                }
            }
        }
    }
}
