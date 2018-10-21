import XCTest
@testable import RxCocoaNetworking
import RxSwift
import RxTest

private let dummyData = "".data(using: .utf8)!

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
    
    // MARK: - ProductionTargetType
    func testValidURLRequestSucceeds() {
        let events = simulatedEvents()
        let expected = [
            next(initialTime, dummyData),
            completed(initialTime)
        ]
        XCTAssertEqual(events, expected)
    }
    
    func testInvalidURLReturnsError() {
        let events = simulatedEvents(target: MockProductionTarget.wrongURL)
        XCTAssertThrowsError(events)
    }
    
    func testDelayedStubRespondsAfterDelay() {
        let integerResponseDelay = 5
        let responseDelay = TimeInterval(integerResponseDelay)
        
        let events = simulatedEvents(stubBehavior: .delayed(time: responseDelay, stub: .success(dummyData)))
        
        let expected = [
            next(integerResponseDelay, dummyData),
            completed(integerResponseDelay)
        ]
        
        XCTAssertEqual(events, expected)
    }
    
    func testDelayedStubRespondsImmediatelyForNegativeDelay() {
        let events = simulatedEvents(stubBehavior: .delayed(time: -1, stub: .success(dummyData)))
        
        let expected = [
            next(initialTime, dummyData),
            completed(initialTime)
        ]
        
        XCTAssertEqual(events, expected)
    }
    
    func testDelayedStubRespondsImmediatelyForZeroDelay() {
        let events = simulatedEvents(stubBehavior: .delayed(time: 0, stub: .success(dummyData)))
        
        let expected = [
            next(initialTime, dummyData),
            completed(initialTime)
        ]
        
        XCTAssertEqual(events, expected)
    }
    
    func testSuccessStubTriggersSuccessInProduction() {
        let stubbedData = "".data(using: .utf8)!
        let events = simulatedEvents(stubBehavior: .immediate(stub: .success(stubbedData)))
        
        let expected = [
            next(initialTime, stubbedData),
            completed(initialTime)
        ]
        
        XCTAssertEqual(events, expected)
    }
    
    func testErrorStubTriggersErrorInProduction() {
        let events = simulatedEvents(stubBehavior: .immediate(stub: .error(TestError.someError)))
        XCTAssertThrowsError(events)
    }
    
    func testDefaultStubTriggersErrorInProduction() {
        let events = simulatedEvents(stubBehavior: .immediate(stub: .default))
        XCTAssertThrowsError(events)
    }
    
    private func simulatedEvents(stubBehavior: StubBehavior = .immediate(stub: .success(dummyData)),
                                 target: MockProductionTarget = MockProductionTarget.validURL)
        -> [Recorded<Event<Data>>] {
            let provider = Provider<MockProductionTarget>(stubBehavior: stubBehavior, scheduler: scheduler)
            let results = scheduler.createObserver(Data.self)
            
            scheduler.scheduleAt(initialTime) {
                provider.request(target).asObservable()
                    .subscribe(results).disposed(by: self.disposeBag)
            }
            scheduler.start()
            
            return results.events
    }
    
    // MARK: - TargetType
    func testDefaultStubTriggersSampleData() {
        let events = simulatedEvents(stubBehavior: .immediate(stub: .default),
                                     target: MockTarget.validURL)
        
        let expected = [
            next(initialTime, MockTarget.validURL.sampleData),
            completed(initialTime)
        ]
        
        XCTAssertEqual(events, expected)
    }
    
    func testSuccessStubTriggersSuccess() {
        let stubbedData = "".data(using: .utf8)!
        let events = simulatedEvents(stubBehavior: .immediate(stub: .success(stubbedData)),
                                     target: MockTarget.validURL)
        
        let expected = [
            next(initialTime, stubbedData),
            completed(initialTime)
        ]
        
        XCTAssertEqual(events, expected)
    }
    
    func testErrorStubTriggersError() {
        let events = simulatedEvents(stubBehavior: .immediate(stub: .error(TestError.someError)),
                                     target: MockTarget.validURL)
        XCTAssertThrowsError(events)
    }
    
    private func simulatedEvents(stubBehavior: StubBehavior,
                                 target: MockTarget) -> [Recorded<Event<Data>>] {
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

private enum MockProductionTarget: ProductionTargetType {
    case validURL
    case wrongURL
    
    var baseURL: URL { return "http://www.foo.com" }
    
    var path: String {
        switch self {
        case .validURL: return "/foo"
        case .wrongURL: return "/)!$%*#"
        }
    }
    
    var task: Task { return Task() }
    
    var headers: [String : String]? { return [:] }
}

private enum MockTarget: TargetType {
    case validURL
    
    var baseURL: URL { return MockProductionTarget.validURL.baseURL }
    
    var path: String { return MockProductionTarget.validURL.path }
    
    var task: Task { return Task() }
    
    var headers: [String : String]? { return MockProductionTarget.validURL.headers }
    
    var sampleData: Data { return dummyData }
}
