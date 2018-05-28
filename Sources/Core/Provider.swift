import Foundation
import RxCocoa
import RxSwift

enum ProviderError: Error {
    case invalidURL
}

/// A self-mockable network data requester.
final public class Provider<Target: TargetType> {
    private let stubBehavior: StubBehavior
    private let scheduler: SchedulerType
    
    public init(stubBehavior: StubBehavior = .never,
         scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        self.stubBehavior = stubBehavior
        self.scheduler = scheduler
    }
    
    public func request(_ target: Target) -> Single<Data> {
        guard let url = URL(string: target.baseURL.absoluteString + target.path) else {
            return .error(ProviderError.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = target.headers
        request.httpBody = target.task.body
        request.httpMethod = target.task.method.rawValue
        if let parameters = target.task.parameters {
            request = request.addingParameters(parameters)
        }
        
        return target.makeURLSession(stubBehavior: stubBehavior, scheduler: scheduler)
            .data(request: request).asSingle()
    }
}

// MARK: - Private
// Entities and methods that are not supposed to be used outside a Provider
private struct ReactiveURLSessionMock: ReactiveURLSessionProtocol {
    private let stub: Stub
    private let scheduler: SchedulerType
    private let delay: TimeInterval
    
    init(stub: Stub, scheduler: SchedulerType, delay: TimeInterval = 0) {
        self.stub = stub
        self.scheduler = scheduler
        self.delay = delay
    }
    
    func data(request: URLRequest) -> Observable<Data> {
        switch stub {
        case .success(let data):
            let immediateResponse = Observable.just(data)
            guard delay > 0 else { return immediateResponse }
            return immediateResponse.delay(delay, scheduler: scheduler)
        case .error(let error):
            return .error(error)
        case .default:
            fatalError("Unhandled default stub")
        }
    }
}

private extension TargetType {
    func makeURLSession(stubBehavior: StubBehavior,
                        scheduler: SchedulerType) -> ReactiveURLSessionProtocol {
        switch stubBehavior {
        case .delayed(let time, let stub):
            return ReactiveURLSessionMock(stub: makeStub(from: stub), scheduler: scheduler, delay: time)
        case .immediate(let stub):
            return ReactiveURLSessionMock(stub: makeStub(from: stub), scheduler: scheduler)
        case .never:
            return URLSession.shared.rx
        }
    }
    
    func makeStub(from baseStub: Stub) -> Stub {
        switch baseStub {
        case .default:
            return Stub.success(sampleData)
        case .error, .success:
            return baseStub
        }
    }
}
