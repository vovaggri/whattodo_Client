//
//  BottomVC.swift

import UIKit

protocol BottomSheetDelegate: AnyObject {
    func changeDetent(to detent: UISheetPresentationController.Detent.Identifier)
}

final class BottomSheetViewController: UIViewController {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
        
        static let textConstraints: Double = 20
        static let textColor: String = "000000"
        static let textSize: CGFloat = 20
        
        static let todayLabelText: String = "Todays tasks"
        static let todayAlpha: CGFloat = 0.8
        
        static let switcherSmallText: String = "See all"
        static let switcherLargreText: String = "Less"
        static let switcherAlpha: CGFloat = 0.34
    }
    
    var interactor: BottomBusinessLogic?
    weak var delegate: BottomSheetDelegate?
    
    private let todayLabel: UILabel = UILabel()
    private let presentSwictherButton: UIButton = UIButton(type: .system)
    private var tasks: [Task] = []
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8    // Отступ между строками
        layout.minimumInteritemSpacing = 8 // Отступ между ячейками в ряду
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collection.backgroundColor = .clear
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F0F1F1")
        
        if let sheet = self.sheetPresentationController {
            sheet.delegate = self
        }
        
        interactor?.loadTasks()
        configureUI()
        configureTaskCollection()
    }
    
    func updateSwitcherButton(title: String) {
        presentSwictherButton.setTitle(title, for: .normal)
    }
    
    func showTasks(with tasks: [Task]) {
        self.tasks = tasks
    }
    
    private func configureUI() {
        configureTodayLabel()
        configureSwitcherButton()
    }
    
    private func configureTodayLabel() {
        view.addSubview(todayLabel)
        
        todayLabel.font = UIFont(name: Constants.fontName, size: Constants.textSize)
        todayLabel.text = Constants.todayLabelText
        todayLabel.textColor = UIColor(hex: Constants.textColor, alpha: Constants.todayAlpha)
        
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        todayLabel.pinTop(to: view, Constants.textConstraints)
        todayLabel.pinLeft(to: view, Constants.textConstraints)
    }
    
    private func configureSwitcherButton() {
        view.addSubview(presentSwictherButton)
        presentSwictherButton.setTitle(Constants.switcherSmallText, for: .normal)
        presentSwictherButton.setTitleColor(UIColor(hex: Constants.textColor, alpha: Constants.switcherAlpha), for: .normal)
        presentSwictherButton.titleLabel?.font = UIFont(name: Constants.fontName, size: Constants.textSize)
        
        presentSwictherButton.translatesAutoresizingMaskIntoConstraints = false
        presentSwictherButton.pinTop(to: view, Constants.textConstraints)
        presentSwictherButton.pinRight(to: view, Constants.textConstraints)
        
        presentSwictherButton.addTarget(self, action: #selector(switcherPressed), for: .touchUpInside)
    }
    
    private func configureTaskCollection() {
        // Регистрируем нашу кастомную ячейку
        if tasks.isEmpty {
            collectionView.register(EmptyTaskCell.self, forCellWithReuseIdentifier: EmptyTaskCell.Constants.identifier)
        } else {
            collectionView.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.Constants.identifier)
        }
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.pinTop(to: todayLabel.bottomAnchor, 30)
        collectionView.pinLeft(to: view.leadingAnchor)
        collectionView.pinRight(to: view.trailingAnchor)
        collectionView.pinBottom(to: view.bottomAnchor)
    }
    
    @objc private func switcherPressed() {
        interactor?.switcherPressed()
    }
}

extension BottomSheetViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        interactor?.detentChanged(newDetent: sheetPresentationController.selectedDetentIdentifier)
    }
}

extension BottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return TasksTest.tasks.count
        if tasks.isEmpty {
            return 1
        } else {
            return tasks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if tasks.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyTaskCell.Constants.identifier, for: indexPath) as? EmptyTaskCell else {
                return UICollectionViewCell()
            }
            
            cell.configure()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.Constants.identifier, for: indexPath) as? TaskCell else {
                return UICollectionViewCell()
            }
            
            let task = TasksTest.tasks[indexPath.row]
            cell.configure(with: task)
            return cell
        }
    }
}

extension BottomSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !tasks.isEmpty {
            let selectedTask = TasksTest.tasks[indexPath.row]
            print("Selected: \(selectedTask.title)")
        }
    }
}

extension BottomSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Пример: ширина = вся ширина экрана с отступами 16, высота = 50
        let width = collectionView.bounds.width - 16
        let height: CGFloat = 158
        return CGSize(width: width, height: height)
    }
}

