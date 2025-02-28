import UIKit

protocol MainScreenDisplayLogic: AnyObject {
    func displayMainScreenData(viewModel: MainScreen.Fetch.ViewModel)
}

class MainScreenViewController: UIViewController, MainScreenDisplayLogic {
    
    // VIP references
    var interactor: MainScreenBusinessLogic?
    var presenter: MainScreenPresentationLogic?
    
    // Only the header view
    private let headerView = HeaderView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupVIP()
        setupHeader()
        
        // Fetch only header data
        let request = MainScreen.Fetch.Request()
        interactor?.fetchMainScreenData(request: request)
    }
    
    // MARK: - Setup VIP
    private func setupVIP() {
        let interactor = MainScreenInteractor()
        let presenter = MainScreenPresenter()
        self.interactor = interactor
        self.presenter = presenter
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    // MARK: - Setup Header
    private func setupHeader() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - MainScreenDisplayLogic
    func displayMainScreenData(viewModel: MainScreen.Fetch.ViewModel) {
        // Update header with greeting & avatar
        headerView.displayHeader(greeting: viewModel.greetingText, avatar: viewModel.avatarImage)
    }
}
