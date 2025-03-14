import UIKit

final class MainScreenViewController: UIViewController {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        
        static let smallIdentifier: String = "small"
    }
    
    // SVIP references
    var interactor: MainScreenBusinessLogic?
    var presenter: MainScreenPresentationLogic?
    
    // Only the header view
    private let headerView = HeaderView(frame: .zero)
    private var bottomSheetVC: BottomSheetViewController?
    
    private var categories: [MainScreen.Fetch.CategoryViewModel] = []
    
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    private func setupCollectionViewConstraints() {
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupHeader()
        view.addSubview(categoriesCollectionView)
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")

        setupCollectionViewConstraints()
        
        let request = MainScreen.Fetch.Request()
        interactor?.fetchMainScreenData(request: request)
        
        presentBottomSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Если bottomVC не представлен (был dismissed), создаем и презентуем его заново
        if bottomSheetVC?.presentingViewController == nil {
            presentBottomSheet()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if categories.isEmpty,
           let layout = categoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellHeight: CGFloat = 135
            let screenCenterY = view.bounds.midY
            let collectionViewTopY = categoriesCollectionView.frame.minY
            let topInset = max(0, screenCenterY - (cellHeight / 2) - collectionViewTopY)
            layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        } else if let layout = categoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        }
    }
    
    // MARK: - MainScreenDisplayLogic
    func displayMainScreenData(viewModel: MainScreen.Fetch.ViewModel) {
        headerView.displayHeader(greeting: viewModel.greetingText, avatar: viewModel.avatarImage)
    }
    
    // MARK: - Setup Header
    private func setupHeader() {
        view.addSubview(headerView)
        headerView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        headerView.pinLeft(to: view)
        headerView.pinRight(to: view)
    }
    
    private func presentBottomSheet() {
        // Создаем новый экземпляр bottomVC
        let bottomVC = BottomAssembly.assembly()
        bottomVC.delegate = self
                
        if #available(iOS 16, *) {
            let smallDetent = UISheetPresentationController.Detent.custom(identifier: .init(Constants.smallIdentifier)) { context in
                let screenHeight = UIScreen.main.bounds.height
                return screenHeight * 0.3
            }
                    
            if let sheet = bottomVC.sheetPresentationController {
                sheet.detents = [smallDetent, .large()]
                sheet.largestUndimmedDetentIdentifier = smallDetent.identifier
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersGrabberVisible = false
                bottomVC.isModalInPresentation = true
                sheet.preferredCornerRadius = 40.0
            }
        } else {
            if let sheet = bottomVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersGrabberVisible = false
                bottomVC.isModalInPresentation = true
            }
        }
        
        bottomSheetVC = bottomVC
        present(bottomVC, animated: true, completion: nil)
    }
    
    private func presentCreateGoalScreen() {
        bottomSheetVC?.dismiss(animated: false) { [weak self] in
            self?.interactor?.navigateToCreateGoal()
        }
    }
}

extension MainScreenViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}

extension MainScreenViewController: BottomSheetDelegate {
    func changeDetent(to detent: UISheetPresentationController.Detent.Identifier) {
        guard let sheet = bottomSheetVC?.sheetPresentationController else { return }
        sheet.animateChanges {
            sheet.selectedDetentIdentifier = detent
        }
    }
}

extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        if indexPath.item == 0 {
            cell.configureAsAddGoal()
        } else {
            let category = categories[indexPath.item - 1]
            cell.configure(with: category)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            presentCreateGoalScreen()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
         let totalSpacing = 16 * 3
         let width = (view.frame.width - CGFloat(totalSpacing)) / 2
         return CGSize(width: width, height: 100)
     }
}

