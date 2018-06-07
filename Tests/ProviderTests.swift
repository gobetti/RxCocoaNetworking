import XCTest
@testable import RxCocoaNetworking
import RxSwift
import RxTest

enum TestError: Error {
    case someError
}

class ProviderTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    let initialTime = 0
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
    }
    
    func testValidURLRequestSucceeds() {
        let events = simulatedEvents()
        let expected = [
            next(initialTime, MockTarget.validURL.sampleData),
            completed(initialTime)
        ]
        XCTAssertEqual(events, expected)
    }
    
    func testInvalidURLReturnsError() {
        let events = simulatedEvents(target: MockTarget.wrongURL)
        XCTAssertThrowsError(events)
    }
    
    func testDelayedStubRespondsAfterDelay() {
        let integerResponseDelay = 5
        let responseDelay = TimeInterval(integerResponseDelay)
        
        let events = simulatedEvents(stubBehavior: .delayed(time: responseDelay, stub: .default))
        
        let expected = [
            next(integerResponseDelay, MockTarget.validURL.sampleData),
            completed(integerResponseDelay)
        ]
        
        XCTAssertEqual(events, expected)
    }
    
    func testSuccessStubTriggersSuccess() {
        let stubbedData = "".data(using: .utf8)!
        let events = simulatedEvents(stubBehavior: .immediate(stub: .success(stubbedData)))
        
        let expected = [
            next(initialTime, stubbedData),
            completed(initialTime)
        ]
        
        XCTAssertEqual(events, expected)
    }
    
    func testErrorStubTriggersError() {
        let events = simulatedEvents(stubBehavior: .immediate(stub: .error(TestError.someError)))
        XCTAssertThrowsError(events)
    }
    
    private func simulatedEvents(stubBehavior: StubBehavior = .immediate(stub: .default),
                                 target: MockTarget = MockTarget.validURL)
        -> [Recorded<Event<Data>>] {
            let provider = Provider<MockTarget>(stubBehavior: stubBehavior, scheduler: scheduler)
            let results = scheduler.createObserver(Data.self)
            
            scheduler.scheduleAt(initialTime) {
                provider.request(target).asObservable()
                    .subscribe(results).disposed(by: self.disposeBag)
            }
            scheduler.start()
            
            return results.events
    }
}

private enum MockTarget: TargetType {
    case validURL
    case wrongURL
    
    var baseURL: URL { return URL(string: "www.foo.com")! }
    
    var path: String {
        switch self {
        case .validURL: return ""
        case .wrongURL: return ")!$%*#"
        }
    }
    
    var task: Task { return Task(method: .get) }
    
    var headers: [String : String]? { return [:] }
    
    var sampleData: Data { return "".data(using: .utf8)! }
}
