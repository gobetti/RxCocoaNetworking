import Foundation
import RxCocoa
import RxSwift

protocol ReactiveURLSessionProtocol {
    func data(request: URLRequest) -> Observable<Data>
}

extension Reactive: ReactiveURLSessionProtocol where Base: URLSession {}
