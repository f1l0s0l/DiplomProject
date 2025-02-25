protocol APIClient {
    func perform<T: APIRequest>(request: T, completion: @escaping (Result<T.ResultValue, Error>) -> Void)
}

protocol APIRequest {
    associatedtype ResultValue
    
    var method: String { get }
    var parameters: [String: String] { get }
}

extension APIRequest {
    var method: String {
        String(describing: Self.self)
    }
}

enum API {}
