import UIKit

final class MainScreenViewController: UIViewController {
    
    // SVIP references
    var interactor: MainScreenBusinessLogic?
    
    // Only the header view
    private let headerView = HeaderView(frame: .zero)
    private let bottomSheetVC = BottomSheetViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F0F1F1")

        setupHeader()
        
        // Fetch only header data
        let request = MainScreen.Fetch.Request()
        interactor?.fetchMainScreenData(request: request)
        
        
        if #available(iOS 16, *) {
            let smallDetent = UISheetPresentationController.Detent.custom(identifier: .init("small")) { context in
                return 300
            }
            
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [
                    smallDetent,
                    .large()
                ]
                
                sheet.largestUndimmedDetentIdentifier = smallDetent.identifier
                
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersGrabberVisible = false
                bottomSheetVC.isModalInPresentation = true
            }
        } else {
            if let sheet = bottomSheetVC.sheetPresentationController {
                sheet.detents = [
                    .medium(),
                    .large()
                ]
                
                sheet.largestUndimmedDetentIdentifier = .medium
                
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                
                sheet.prefersGrabberVisible = false
                
                bottomSheetVC.isModalInPresentation = true
            }
        }
        
        present(bottomSheetVC, animated: false)
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

extension MainScreenViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}
