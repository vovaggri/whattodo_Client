protocol SettingsBusinessLogic {
    
}

final class SettingsInteractor: SettingsBusinessLogic {
    private var presenter: SettingsPresentationLogic?
    private var worker: SettingsWorkerProtocol?
    
    init(presenter: SettingsPresentationLogic?, worker: SettingsWorkerProtocol?) {
        self.presenter = presenter
        self.worker = worker
    }
}
