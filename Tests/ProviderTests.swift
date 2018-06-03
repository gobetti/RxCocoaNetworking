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
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
    }
    
    func testValidURLRequestSucceeds() {
        let events = self.simulatedEvents()
        let expected = [
            next(self.initialTime, MockTarget.validURL.sampleData),
            completed(self.initialTime)
        ]
        XCTAssertEqual(events, expected)
    }
    
    func testInvalidURLReturnsError() {
        let events = self.simulatedEvents(target: MockTarget.wrongURL)
        XCTAssertThrowsError(events)
    }
    
    func testDelayedStubRespondsAfterDelay() {
        let integerResponseDelay = 5
        let responseDelay = TimeInterval(integerResponseDelay)
        
        let events = self.simulatedEvents(stubBehavior: .delayed(time: responseDelay, stub: .default))
        
        let expected = [
            next(integerResponseDelay, MockTarget.validURL.sampleData),
            completed(integerResponseDelay)
        ]
        
        XCTAssertEqual(events, expected)
    }
    
    func testErrorStubReturnsError() {
        let events = self.simulatedEvents(stubBehavior: .immediate(stub: .error(TestError.someError)))
        XCTAssertThrowsError(events)
    }
    
    private func simulatedEvents(stubBehavior: StubBehavior = .immediate(stub: .default),
                                 target: MockTarget = MockTarget.validURL)
        -> [Recorded<Event<Data>>] {
            let provider = Provider<MockTarget>(stubBehavior: stubBehavior, scheduler: self.scheduler)
            let results = scheduler.createObserver(Data.self)
            
            scheduler.scheduleAt(self.initialTime) {
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
