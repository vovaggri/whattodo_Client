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
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor        = .lightGray
        pc.hidesForSinglePage           = true
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    
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
        categoriesCollectionView.isPagingEnabled = false
        categoriesCollectionView.delegate = self

        setupHeader()
        
        
        view.addSubview(bottomAnchorGuide)
        configureButtonAnchorGuide()
        // 1) Configure your collection view
          categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate   = self
          categoriesCollectionView.isPagingEnabled = true
        categoriesCollectionView.showsHorizontalScrollIndicator = false

          // 2) Register your custom cells
          categoriesCollectionView.register(CatCell.self,
                                            forCellWithReuseIdentifier: CatCell.reuseIdentifier)
          categoriesCollectionView.register(CategoryCell.self,
                                            forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)

          // 3) Kick off your fetch
          interactor?.fetchMainScreenData(request: MainModels.Fetch.Request())

          // 4) Finally, add it to the view hierarchy and set up constraints
          view.addSubview(categoriesCollectionView)
          setupCollectionViewConstraints()
        view.addSubview(pageControl)
           pageControl.pinTop(to: categoriesCollectionView.bottomAnchor, 8)
           pageControl.pinCenterX(to: view.centerXAnchor)


        
        let request = MainModels.Fetch.Request()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.register(CatCell.self, forCellWithReuseIdentifier: "CatCell")
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        interactor?.fetchMainScreenData(request: request)
        view.addSubview(categoriesCollectionView)

        setupCollectionViewConstraints()
        view.addSubview(pageControl)
        pageControl.pinTop(to: categoriesCollectionView.bottomAnchor, 8)
        pageControl.pinCenterX(to: view.centerXAnchor)
        
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

        // one “page” is one compositional group = 3 items (big + 2 small)
        let pages = Int( ceil(Double(goals.count + 1) / 3.0) )
        pageControl.numberOfPages = max(pages, 1)
        pageControl.currentPage   = 0
    }

    func didSelectTask(_ task: Task) {
        bottomSheetVC?.dismiss(animated: true) { [weak self] in
            let reviewVC = ReviewScreenAssembly.assembly(task)
            self?.navigationController?.pushViewController(reviewVC, animated: true)
        }
    }
    
    func didSelectGoal(_ goal: Goal){
        bottomSheetVC?.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let goalVC = GoalReviewAssembly.assembly(goal)
            navigationController?.pushViewController(goalVC, animated: true)
        }

    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
      return UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
        guard let self = self else { return nil }
        let fullHeight = NSCollectionLayoutDimension.fractionalHeight(1.0)

        // 1) Big left item
        let bigItem = NSCollectionLayoutItem(
          layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                            heightDimension: fullHeight)
        )
        bigItem.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)

        // 2) Two small right items
        let smallItem = NSCollectionLayoutItem(
          layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                            heightDimension: .fractionalHeight(0.5))
        )
        smallItem.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        let smallGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                            heightDimension: fullHeight),
          subitems: [smallItem, smallItem]
        )

        // 3) Combine into one group
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                            heightDimension: fullHeight),
          subitems: [bigItem, smallGroup]
        )

        // 4) Section
          let section = NSCollectionLayoutSection(group: group)
             section.contentInsets = .init(top: 8, leading: 10, bottom: 8, trailing: 10)
             section.interGroupSpacing = 8
             section.orthogonalScrollingBehavior = .groupPagingCentered

             section.visibleItemsInvalidationHandler = { _, offset, environment in
               // 1) Grab the number of pages
               let pages = self.pageControl.numberOfPages
               guard pages > 0 else { return }

               // 2) The “page width” is exactly the width of one group on screen:
               let pageWidth = environment.container.effectiveContentSize.width
               guard pageWidth > 0 else { return }

               // 3) Compute which page we’re on
               let rawPage = offset.x / pageWidth
               let current = Int(round(rawPage))

               // 4) Clamp & assign
               let clamped = min(max(current, 0), pages - 1)
               DispatchQueue.main.async {
                 self.pageControl.currentPage = clamped
               }
             }

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
    
    // MARK: - Setup Header
    private func setupHeader() {
        view.addSubview(headerView)
        headerView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        headerView.pinLeft(to: view.leadingAnchor)
        headerView.pinRight(to: view.trailingAnchor)
        headerView.pinBottom(to: headerView.bottomAnchorView.bottomAnchor, 16)
        
        headerView.delegate = self
    }
    
    private func presentBottomSheet() {
        // Создаем новый экземпляр bottomVC
        let bottomVC = BottomAssembly.assembly()
        bottomVC.delegate = self
                
        if #available(iOS 16, *) {
            let smallDetent = UISheetPresentationController.Detent.custom(identifier: .init(Constants.smallIdentifier)) { context in
                let screenHeight = UIScreen.main.bounds.height
                return screenHeight * 0.355
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
    private func makeFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection          = .horizontal
        layout.minimumLineSpacing       = 8
        layout.minimumInteritemSpacing  = 8
        // equal 20‑point margins on left & right
        layout.sectionInset            = UIEdgeInsets(top: 8,
                                                     left: 20,
                                                     bottom: 8,
                                                     right: 20)
        return layout
      }

    private func configureCalendarButton() {
        view.addSubview(calendarButton)
        
        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        
        calendarButton.pinTop(to: headerView.topAnchor)
        calendarButton.pinRight(to: view.trailingAnchor, 20)
        
        calendarButton.backgroundColor = .black
        calendarButton.setImage(UIImage(systemName: Constants.calendarButtonName), for: .normal)
        calendarButton.tintColor = .white
        
        calendarButton.setHeight(80)
        calendarButton.setWidth(80)
        calendarButton.layer.cornerRadius = 38
     calendarButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
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
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Если целей нет – показываем только ячейку “Добавить цель”
        if goals.isEmpty {
            let addCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCell.reuseIdentifier,
                for: indexPath
            ) as! CategoryCell
            addCell.configureAsAddGoal()
            return addCell
        }
        
        // Если индекс меньше количества целей — показываем цель
        if indexPath.item < goals.count {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CatCell.reuseIdentifier,
                for: indexPath
            ) as! CatCell
            let goal = goals[indexPath.item]
            cell.configure(with: goal, progress: goal.progress)
            return cell
        }
        
        // В остальных случаях — ячейка “Добавить цель”
        let addCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCell.reuseIdentifier,
            for: indexPath
        ) as! CategoryCell
        addCell.configureAsAddGoal()
        return addCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if goals.isEmpty {
            presentCreateGoalScreen()
        } else {
            if indexPath.item == goals.count {
                presentCreateGoalScreen()
            } else {
                print("Pressed goal: \(goals[indexPath.item].title)")
                didSelectGoal(goals[indexPath.item])
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
            let width = screenWidth / 2 - 19
            let layout = collectionViewLayout as? UICollectionViewFlowLayout
            let topInset = layout?.sectionInset.top ?? 0
            let bottomInset = layout?.sectionInset.bottom ?? 0
            let height = (collectionView.bounds.height - topInset - bottomInset) / 2
            
            return CGSize(width: width, height: height)
        } else if indexPath.row % 2 == 0 {
            let screenWidth = UIScreen.main.bounds.width
            let width = screenWidth / 2 - 19
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
    
    func collectionView(_ cv: UICollectionView,
                        layout layout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let flow = layout as? UICollectionViewFlowLayout else {
            return .zero
        }
        // 1) your cell width (must exactly match what you return in sizeForItemAt)
        let cellWidth = (cv.bounds.width / 2) - 24

        // 2) how many cells in this section?
        let count: CGFloat = goals.isEmpty ? 1 : CGFloat(goals.count + 1)

        // 3) total content width (cells + spacing)
        let totalCellWidth = count * cellWidth
        let totalSpacing   = max(count - 1, 0) * flow.minimumInteritemSpacing

        // 4) leftover space / 2 = horizontal inset
        let horizontalPadding = max((cv.bounds.width - (totalCellWidth + totalSpacing)) / 2, 0)

        return UIEdgeInsets(top:    flow.sectionInset.top,
                            left:   horizontalPadding,
                            bottom: flow.sectionInset.bottom,
                            right:  horizontalPadding)
    }
}



//xtension MainScreenViewController: UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
//    }
extension MainScreenViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard scrollView == categoriesCollectionView else { return }
    let pageWidth = scrollView.bounds.width
    guard pageWidth > 0 else { return }
    // contentOffset.x will be a multiple of pageWidth
    let page = Int(scrollView.contentOffset.x / pageWidth)
    pageControl.currentPage = min(max(page, 0), pageControl.numberOfPages - 1)
  }
}

extension MainScreenViewController: HeaderViewDelegate {
    func headerViewDidTapGreeting(_ headerView: HeaderView) {
        bottomSheetVC?.dismiss(animated: true) { [weak self] in
            let settingsVC = SettingsAssembly.assembly()
            self?.navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
}

