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
    private let stubbed: Observable<Data>
    private let scheduler: SchedulerType
    private let delay: TimeInterval
    
    init(stubbed: Observable<Data>, scheduler: SchedulerType, delay: TimeInterval = 0) {
        self.stubbed = stubbed
        self.scheduler = scheduler
        self.delay = delay
    }
    
    func data(request: URLRequest) -> Observable<Data> {
        guard delay > 0 else { return stubbed }
        return stubbed.delay(delay, scheduler: scheduler)
    }
}

private extension TargetType {
    func makeURLSession(stubBehavior: StubBehavior,
                        scheduler: SchedulerType) -> ReactiveURLSessionProtocol {
        switch stubBehavior {
        case .delayed(let time, let stub):
            return ReactiveURLSessionMock(stubbed: stub.makeResponse(for: self),
                                          scheduler: scheduler,
                                          delay: time)
        case .immediate(let stub):
            return ReactiveURLSessionMock(stubbed: stub.makeResponse(for: self),
                                          scheduler: scheduler)
        case .never:
            return URLSession.shared.rx
        }
    }
}

private extension Stub {
    func makeResponse(for target: TargetType) -> Observable<Data> {
        switch self {
        case .default:
            return .just(target.sampleData)
        case .success(let data):
            return .just(data)
        case .error(let error):
            return .error(error)
        }
    }
}
