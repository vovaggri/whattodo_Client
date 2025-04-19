import UIKit

final class MainScreenViewController: UIViewController {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        
        static let smallIdentifier: String = "small"
        static let calendarButtonName: String = "calendar"
    }
    
    // SVIP references
    var interactor: MainScreenBusinessLogic?
    
    // Only the header view
    private let headerView = HeaderView(frame: .zero)
    private let calendarButton: UIButton = UIButton(type: .system)
    private let bottomAnchorGuide = UIView()
    private var bottomAnchorGuideConstraint: NSLayoutConstraint?
    private var bottomSheetVC: BottomSheetViewController?
    private var goals: [Goal] = []
  
    //private let keychainService = KeychainService()
    
    private var categories: [MainModels.Fetch.CategoryViewModel] = []
    
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = self.createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupHeader()
        
        view.addSubview(bottomAnchorGuide)
        configureButtonAnchorGuide()
        
        let request = MainModels.Fetch.Request()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.register(CatCell.self, forCellWithReuseIdentifier: "CatCell")
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        interactor?.fetchMainScreenData(request: request)
        view.addSubview(categoriesCollectionView)

        setupCollectionViewConstraints()
        
//        presentBottomSheet()
        configureCalendarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.loadGoals()
        
        // Если bottomVC не представлен (был dismissed), создаем и презентуем его заново
        if bottomSheetVC?.presentingViewController == nil {
            presentBottomSheet()
        }
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("Header height:", headerView.frame.height)
        print("CollectionView frame:", categoriesCollectionView.frame)
    }
    
    // MARK: - MainScreenDisplayLogic
    func displayMainScreenData(viewModel: MainModels.Fetch.ViewModel) {
        headerView.displayHeader(greeting: viewModel.greetingText, avatar: viewModel.avatarImage)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showGoals(with goals: [Goal]) {
        self.goals = goals
        categoriesCollectionView.reloadData()
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            // Set the size of the group in absolute or fractional values ​​relative to the width of collectionView.
            // Group has full height of collectionView
            let fullHeight: NSCollectionLayoutDimension = .fractionalHeight(1.0)
            // Left part: big element
            let bigItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: fullHeight)
            let bigItem = NSCollectionLayoutItem(layoutSize: bigItemSize)
            
            // Right part: two small elements
            let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
            let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
            smallItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            let smallGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: fullHeight)
            let smallGroup = NSCollectionLayoutGroup.vertical(layoutSize: smallGroupSize, subitems: Array(repeating: smallItem, count: 2))
            
            // Horizonal group with big and small elements
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: fullHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [bigItem, smallGroup])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            section.interGroupSpacing = 8
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
    }
    
    private func setupCollectionViewConstraints() {
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.pinTop(to: headerView.bottomAnchor, 20)
        categoriesCollectionView.pinLeft(to: view.leadingAnchor, 10)
        categoriesCollectionView.pinRight(to: view.trailingAnchor, 10)
        categoriesCollectionView.pinBottom(to: bottomAnchorGuide.topAnchor, 35)
    }
    
    private func configureButtonAnchorGuide() {
        bottomAnchorGuide.translatesAutoresizingMaskIntoConstraints = false
        bottomAnchorGuide.pinLeft(to: view.leadingAnchor)
        bottomAnchorGuide.pinRight(to: view.trailingAnchor)
            
        let bottomOffset = UIScreen.main.bounds.height * 0.4
        bottomAnchorGuideConstraint = bottomAnchorGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomOffset)
        bottomAnchorGuideConstraint?.isActive = true
            
        bottomAnchorGuide.setHeight(1)
    }
    
    private func pushCreateTaskVC() {
        let createTaskVC = CreateTaskAssembly.assembly(delegate: self as? CreateTaskViewControllerDelegate)
        bottomSheetVC?.dismiss(animated: false) { [weak self] in
            self?.navigationController?.pushViewController(createTaskVC, animated: true)
        }
    }
    
    private func pushCalendar() {
        let calendarVC = CalendarAssembly.assembly()
        bottomSheetVC?.dismiss(animated: false) { [weak self] in
            self?.navigationController?.pushViewController(calendarVC, animated: true)
        }
    }
    func didSelectTask(_ task: Task) {
        bottomSheetVC?.dismiss(animated: true) { [weak self] in
            let reviewVC = ReviewScreenAssembly.assembly(task)
            self?.navigationController?.pushViewController(reviewVC, animated: true)
        }
    }

    
    // MARK: - Setup Header
    private func setupHeader() {
        view.addSubview(headerView)
        headerView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        headerView.pinLeft(to: view.leadingAnchor)
        headerView.pinRight(to: view.trailingAnchor)
        headerView.pinBottom(to: headerView.bottomAnchorView.bottomAnchor, 16)
    }
    
    private func presentBottomSheet() {
        // Создаем новый экземпляр bottomVC
        let bottomVC = BottomAssembly.assembly()
        bottomVC.delegate = self
                
        if #available(iOS 16, *) {
            let smallDetent = UISheetPresentationController.Detent.custom(identifier: .init(Constants.smallIdentifier)) { context in
                let screenHeight = UIScreen.main.bounds.height
                return screenHeight * 0.4
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
        // If you want to dismiss the bottom sheet first, do it here
        bottomSheetVC?.dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            
            // 1) Build your CreateNewGoal screen
            let createGoalVC = CreateGoalAssembly.assembly()
            
            // 2) Push it on the navigation stack
            self.navigationController?.pushViewController(createGoalVC, animated: true)
        }
    }

    private func configureCalendarButton() {
        view.addSubview(calendarButton)
        
        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        
        calendarButton.pinTop(to: headerView.topAnchor)
        calendarButton.pinRight(to: view.trailingAnchor, 20)
        
        calendarButton.backgroundColor = .black
        calendarButton.setImage(UIImage(systemName: Constants.calendarButtonName), for: .normal)
        calendarButton.tintColor = .white
        
        calendarButton.setHeight(50)
        calendarButton.setWidth(50)
        calendarButton.layer.cornerRadius = 25
        
        calendarButton.addTarget(self, action: #selector(calendarPressed), for: .touchUpInside)
    }
    
    @objc private func calendarPressed() {
        print("Calendar was pressed")
        pushCalendar()
    }
}

// MARK: - Extensions for BottomVC
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
    
    func didTapAddTaskButton() {
        pushCreateTaskVC()
    }
    
    func didTapCalendarButton() {
        pushCalendar()
    }
}

// MARK: - Settings CollectionView
extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if goals.isEmpty {
            return 1
        } else {
            return goals.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if goals.isEmpty {
                // Если целей нет – всегда показываем addCell
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            addCell.configureAsAddGoal()
            return addCell
        } else {
            if indexPath.item < goals.count {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCell", for: indexPath) as? CatCell else {
                    return UICollectionViewCell()
                }
                let goal = goals[indexPath.item]
                let progress = goal.progress
                cell.configure(with: goal, progress: progress)
                return cell
            } else {
                guard let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
                    return UICollectionViewCell()
                }
                addCell.configureAsAddGoal()
                return addCell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if goals.isEmpty {
            presentCreateGoalScreen()
        } else {
            if indexPath.item == goals.count {
                presentCreateGoalScreen()
            } else {
                print("Pressed goal: \(goals[indexPath.item].title)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
        if goals.isEmpty {
            return CGSize(width: 180, height: 135)
        } else if indexPath.row % 3 == 0 {
            let screenWidth = UIScreen.main.bounds.width
            let width = screenWidth / 2 - 24
            let layout = collectionViewLayout as? UICollectionViewFlowLayout
            let topInset = layout?.sectionInset.top ?? 0
            let bottomInset = layout?.sectionInset.bottom ?? 0
            let height = (collectionView.bounds.height - topInset - bottomInset) / 2
            
            return CGSize(width: width, height: height)
        } else if indexPath.row % 2 == 0 {
            let screenWidth = UIScreen.main.bounds.width
            let width = screenWidth / 2 - 24
            let layout = collectionViewLayout as? UICollectionViewFlowLayout
            let topInset = layout?.sectionInset.top ?? 0
            let bottomInset = layout?.sectionInset.bottom ?? 0
            let height = (collectionView.bounds.height - topInset - bottomInset) / 2
            
            return CGSize(width: width, height: height)
        } else {
            let screenWidth = UIScreen.main.bounds.width
            let width = screenWidth / 2 - 24
            let layout = collectionViewLayout as? UICollectionViewFlowLayout
            let topInset = layout?.sectionInset.top ?? 0
            let bottomInset = layout?.sectionInset.bottom ?? 0
            let height = collectionView.bounds.height - topInset - bottomInset
            
            return CGSize(width: width, height: height)
        }
     }
}

extension MainScreenViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
    }
}

