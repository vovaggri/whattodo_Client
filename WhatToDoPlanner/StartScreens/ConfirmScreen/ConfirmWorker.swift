import Foundation

protocol ConfirmWorkerProtocol {
    func sendCode(_ user: ConfirmScreen.UserConfirmRequest, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ConfirmWorker: ConfirmWorkerProtocol {
    private static let url: String = "http://localhost:8000/auth/verify-code"
    private let keychainServer = KeychainService()
    
    func sendCode(_ user: ConfirmScreen.UserConfirmRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        <#code#>
    }
}
