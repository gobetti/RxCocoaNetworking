import Foundation
import RxCocoa
import RxSwift

enum ProviderError: Error {
    case invalidURL
}

/// A self-mockable network data requester.
final public class Provider<Target: ProductionTargetType> {
    private let stubBehavior: StubBehavior<Target.TargetStub>
    private let scheduler: SchedulerType
    
    public init(stubBehavior: StubBehavior<Target.TargetStub> = .never,
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
        
        return URLSessionFactory(target: target)
            .makeURLSession(stubBehavior: stubBehavior, scheduler: scheduler)
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

private struct URLSessionFactory<Target: ProductionTargetType> {
    let target: Target
    
    func makeURLSession(stubBehavior: StubBehavior<Target.TargetStub>,
                        scheduler: SchedulerType) -> ReactiveURLSessionProtocol {
        switch stubBehavior {
        case .delayed(let time, let stub):
            return ReactiveURLSessionMock(stubbed: target.makeResponse(from: stub),
                                          scheduler: scheduler,
                                          delay: time)
        case .immediate(let stub):
            return ReactiveURLSessionMock(stubbed: target.makeResponse(from: stub),
                                          scheduler: scheduler)
        case .never:
            return URLSession.shared.rx
        }
    }
}
