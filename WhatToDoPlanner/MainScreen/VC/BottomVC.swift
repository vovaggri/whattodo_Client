//
//  BottomVC.swift

import UIKit

protocol BottomSheetDelegate: AnyObject {
    func changeDetent(to detent: UISheetPresentationController.Detent.Identifier)
    func didTapAddTaskButton()
    func didTapCalendarButton()
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
        
        static let addButtonName: String = "plus"
        static let calendarButtonName: String = "calendar"
    }
    
    var interactor: BottomBusinessLogic?
    weak var delegate: BottomSheetDelegate?
    
    private let todayLabel: UILabel = UILabel()
    private let presentSwictherButton: UIButton = UIButton(type: .system)
    private let addTaskButton: UIButton = UIButton(type: .system)
//    private let calendarButton: UIButton = UIButton(type: .system)
    private var todayTasks: [Task] = []
    
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
        
        configureUI()
        configureTaskCollection()
        configureAddTaskButton()
        interactor?.loadTasks()
//        configureCalendarButton()
    }
    
    func updateSwitcherButton(title: String) {
        presentSwictherButton.setTitle(title, for: .normal)
    }
    
    func showTasks(with tasks: [Task]) {
        self.todayTasks = tasks
        collectionView.reloadData()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
        collectionView.register(EmptyTaskCell.self, forCellWithReuseIdentifier: EmptyTaskCell.Constants.identifier)
        collectionView.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.Constants.identifier)

        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.pinTop(to: todayLabel.bottomAnchor, 30)
        collectionView.pinLeft(to: view.leadingAnchor)
        collectionView.pinRight(to: view.trailingAnchor)
        collectionView.pinBottom(to: view.bottomAnchor)
    }
    
    private func configureAddTaskButton() {
        view.addSubview(addTaskButton)
        
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        addTaskButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        addTaskButton.pinCenterX(to: view.centerXAnchor)
        
        addTaskButton.backgroundColor = .black
        addTaskButton.setImage(UIImage(systemName: Constants.addButtonName), for: .normal)
        addTaskButton.tintColor = .white
        
        addTaskButton.setHeight(50)
        addTaskButton.setWidth(50)
        addTaskButton.layer.cornerRadius = 25
        
        addTaskButton.addTarget(self, action: #selector(addTaskPressed), for: .touchUpInside)
    }
    
//    private func configureCalendarButton() {
//        view.addSubview(calendarButton)
//        
//        calendarButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        calendarButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
//        calendarButton.pinRight(to: view.trailingAnchor, 50)
//        
//        calendarButton.backgroundColor = .black
//        calendarButton.setImage(UIImage(systemName: Constants.calendarButtonName), for: .normal)
//        calendarButton.tintColor = .white
//        
//        calendarButton.setHeight(50)
//        calendarButton.setWidth(50)
//        calendarButton.layer.cornerRadius = 25
//        
//        calendarButton.addTarget(self, action: #selector(calendarPressed), for: .touchUpInside)
//    }
    
    @objc private func switcherPressed() {
        interactor?.switcherPressed()
    }
    
    @objc private func addTaskPressed() {
        delegate?.didTapAddTaskButton()
    }
//    
//    @objc private func calendarPressed() {
//        print("Calendar was pressed")
//        delegate?.didTapCalendarButton()
//    }
}

extension BottomSheetViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        interactor?.detentChanged(newDetent: sheetPresentationController.selectedDetentIdentifier)
    }
}

extension BottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return TasksTest.tasks.count
        if todayTasks.isEmpty {
            return 1
        } else {
            return todayTasks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if todayTasks.isEmpty {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyTaskCell.Constants.identifier, for: indexPath) as? EmptyTaskCell else {
                return UICollectionViewCell()
            }
            cell.configure()
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.Constants.identifier, for: indexPath) as? TaskCell else {
                return UICollectionViewCell()
            }
            let task = self.todayTasks[indexPath.row]
            cell.configure(with: task)
            cell.delegate = self
            return cell
        }
    }
}

extension BottomSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !todayTasks.isEmpty {
            let selectedTask = todayTasks[indexPath.row]
            print("Selected: \(selectedTask.title)")
        }
    }
}

extension BottomSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 16
        let height: CGFloat = 158
        return CGSize(width: width, height: height)
    }
}

extension BottomSheetViewController: taskCellDelegate {
    func taskCellDidCompleteTask(_ cell: TaskCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
                
        todayTasks[indexPath.row].done.toggle()
        cell.updateCompleteButtonAppearance() // Обновляем визуал
            
        // Здесь должен быть вызов Interactor'а для сохранения изменений в БД/сервере
        // TODO: - Update server
        interactor?.updateTask(todayTasks[indexPath.row])
    }
}

