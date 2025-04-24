import Foundation

protocol SettingsBusinessLogic {
    func fetchUserInfo()
    func logOut()
}

final class SettingsInteractor: SettingsBusinessLogic {
    private var presenter: SettingsPresentationLogic?
    private var worker: SettingsWorkerProtocol?
    
    private let keychainService = KeychainService()
    
    init(presenter: SettingsPresentationLogic?, worker: SettingsWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func fetchUserInfo() {
        worker?.getUser() { [weak self] result in
            switch result {
            case.success(let user):
                print("Self in closure: \(String(describing: self))")
                print("Done")
                DispatchQueue.main.async {                    
                    // TODO: - Make presenter logic
                    self?.presenter?.showUser(user)
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.presenter?.showErrorAlert(error.localizedDescription)
                }
            }
        }
    }
    
    func logOut() {
        keychainService.removeData(forKey: "userToken")
        presenter?.navigateToWelcomeScreen()
    }
}
