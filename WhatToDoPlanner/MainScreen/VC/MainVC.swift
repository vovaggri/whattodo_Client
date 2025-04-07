import UIKit

final class MainScreenViewController: UIViewController {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        
        static let smallIdentifier: String = "small"
        static let calendarButtonName: String = "calendar"
    }
    
    // SVIP references
    var interactor: MainScreenBusinessLogic?
    var presenter: MainScreenPresentationLogic?
    
    // Only the header view
    private let headerView = HeaderView(frame: .zero)
    private let calendarButton: UIButton = UIButton(type: .system)
    private var bottomSheetVC: BottomSheetViewController?
    private var goals: [Goal] = []
  
    //private let keychainService = KeychainService()
    
    private var categories: [MainModels.Fetch.CategoryViewModel] = []
    
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupHeader()
        view.addSubview(categoriesCollectionView)
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")

        setupCollectionViewConstraints()
        
        let request = MainModels.Fetch.Request()
        interactor?.fetchMainScreenData(request: request)
        interactor?.loadGoals()
        
        presentBottomSheet()
        configureCalendarButton()
       
//        if let tokenData = keychainService.getData(forKey: "userToken"), let token = String(data: tokenData, encoding: .utf8) {
//            print("Полученный токен: \(token)")
//            // Здесь можно использовать токен, например, добавить его в заголовок запроса или передать в нужный модуль
//        } else {
//            print("Токен не найден или произошла ошибка преобразования")
//        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Если bottomVC не представлен (был dismissed), создаем и презентуем его заново
        if bottomSheetVC?.presentingViewController == nil {
            presentBottomSheet()
        }
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
    }
    
    private func setupCollectionViewConstraints() {
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        // If you want to dismiss the bottom sheet first, do it here
        bottomSheetVC?.dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            
            // 1) Build your CreateNewGoal screen
            let createGoalVC = CreateGoalAssembly.assemble()
            
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

extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        
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

