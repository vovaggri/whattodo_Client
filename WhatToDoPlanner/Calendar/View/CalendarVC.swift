import UIKit

import UIKit

class WeeklyPagingFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let cv = self.collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        // Calculate page width (which is the collectionView.bounds.width)
        let pageWidth = cv.bounds.width
        let currentOffset = cv.contentOffset.x
        
        // Calculate the target page index based on current offset and velocity
        var targetPage: CGFloat = round(currentOffset / pageWidth)
        
        // Optionally adjust targetPage based on velocity (if user flicks quickly)
        if velocity.x > 0.3 {
            targetPage = floor(currentOffset / pageWidth) + 1
        } else if velocity.x < -0.3 {
            targetPage = ceil(currentOffset / pageWidth) - 1
        }
        
        let newOffset = targetPage * pageWidth
        return CGPoint(x: newOffset, y: proposedContentOffset.y)
    }
}

final class CalendarViewController: UIViewController {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
    }
    
    var interactor: CalendarInteractorProtocol?
    
    // Данные для отображения
    var weeks: [[CalendarModels.CalendarDay]] = []
    var allTasks: [Task] = []
    var tasks: [Task] = []
    
    var selectedDate: Date = Date()
    
    lazy var tasksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate   = self
        cv.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.Constants.identifier)
        return cv
    }()
    
    private lazy var monthNames: [String] = {
        return DateFormatter().monthSymbols
    }()
        
    private lazy var years: [Int] = {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array((currentYear - 10)...(currentYear + 10))
    }()
    
    private lazy var weeksCollectionView: UICollectionView = {
        let layout = WeeklyPagingFlowLayout() // Use your custom layout here
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1.2
        layout.minimumInteritemSpacing = 1.2

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear

        cv.dataSource = self
        cv.delegate = self
        cv.register(DayCell.self, forCellWithReuseIdentifier: DayCell.Constants.reuseId)
        return cv
    }()

    
    private let calendarTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 20)
        label.text = "Calendar"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        // use xmark, scaled up
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let xImage = UIImage(systemName: "xmark", withConfiguration: config)
        button.setImage(xImage, for: .normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.33)
        return button
    }()
    
    // Увеличиваем шрифт и выравниваем по левому краю
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 36) // например, 36
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
   


    
    private lazy var daysOfWeekStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 0

        let daySymbols = ["M", "T", "W", "T", "F", "S", "S"]
        
        for symbol in daySymbols {
            let label = UILabel()
            label.text = symbol
            label.textAlignment = .center
            label.font = UIFont(name: Constants.fontName, size: 14)
            label.textColor = .black
            stack.addArrangedSubview(label)
        }
        return stack
    }()
    
    // MARK: - UI elements for tasks
    private let tasksContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "FAFAFA")
        v.layer.cornerRadius = 25
        v.layer.masksToBounds = true
        return v
    }()
    
    private let tasksTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Your tasks"
        lbl.font = UIFont(name: Constants.fontName, size: 20)
        lbl.textColor = .black
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureCloseButton()
        navigationItem.titleView = calendarTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        setupLayout()
        
        
        // Делаем метку с месяцем интерактивной
        monthLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(monthYearTapped))
        monthLabel.addGestureRecognizer(tapGesture)
        
        
        interactor?.fetchCalendar()
        
        interactor?.loadTasks()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        if let layout = weeksCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            let spacing: CGFloat = 1.2
//            let numberOfDays = 7
//            let gaps = CGFloat(numberOfDays - 1)
//            let totalSpacing = spacing * gaps
//            
//            let usableWidth = weeksCollectionView.bounds.width - totalSpacing
////            let cellWidth = usableWidth / CGFloat(numberOfDays)
//            let cellWidth: CGFloat = 20
//            let cellHeight: CGFloat = 68
//            
//            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
//            layout.minimumLineSpacing = spacing
//            layout.minimumInteritemSpacing = 0
//            
//            layout.invalidateLayout()
//            weeksCollectionView.reloadData()
//        }
    }


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func displayCalendar(viewModel: CalendarModels.CalendarViewModel) {
        let titleText = viewModel.title
        let attributedTitle = NSMutableAttributedString(string: titleText + " ")
        
        let chevronAttachment = NSTextAttachment()
        chevronAttachment.image = UIImage(systemName: "chevron.compact.forward")

        if let image = chevronAttachment.image {
            let yOffset = (monthLabel.font.capHeight - image.size.height) / 2
            chevronAttachment.bounds = CGRect(x: 0, y: yOffset, width: image.size.width, height: image.size.height)
        }
            
        let attachmentString = NSAttributedString(attachment: chevronAttachment)
        attributedTitle.append(attachmentString)
        monthLabel.attributedText = attributedTitle
        
        self.weeks = viewModel.weeks
        weeksCollectionView.reloadData()
        
        // Находим индекс для сегодняшней даты и выделяем ячейку
        if let indexPath = indexPathForDate(selectedDate) {
            weeksCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
    }

    private func indexPathForDate(_ date: Date) -> IndexPath? {
        for (weekIndex, week) in weeks.enumerated() {
            if let dayIndex = week.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                return IndexPath(item: weekIndex * 7 + dayIndex, section: 0)
            }
        }
        return nil
    }
    
    private func setupLayout() {
        view.addSubview(calendarTitle)
        view.addSubview(monthLabel)
        view.addSubview(daysOfWeekStackView)
        view.addSubview(weeksCollectionView)
        
        view.addSubview(tasksContainerView)
        tasksContainerView.translatesAutoresizingMaskIntoConstraints = false

        tasksContainerView.addSubview(tasksTitleLabel)
        tasksContainerView.addSubview(tasksCollectionView)

        tasksTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tasksCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        daysOfWeekStackView.translatesAutoresizingMaskIntoConstraints = false
        weeksCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        monthLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        monthLabel.pinLeft(to: view.leadingAnchor, 16)
        
        daysOfWeekStackView.pinTop(to: monthLabel.bottomAnchor, 16)
        daysOfWeekStackView.pinLeft(to: view.leadingAnchor)
        daysOfWeekStackView.pinRight(to: view.trailingAnchor)
        daysOfWeekStackView.setHeight(30)
        
        weeksCollectionView.pinTop(to: daysOfWeekStackView.bottomAnchor, 8)
        weeksCollectionView.pinLeft(to: view.leadingAnchor)
        weeksCollectionView.pinRight(to: view.trailingAnchor)
        weeksCollectionView.setHeight(68)
        
        tasksContainerView.pinTop(to: weeksCollectionView.bottomAnchor, 24)
        tasksContainerView.pinLeft(to: view.leadingAnchor)
        tasksContainerView.pinRight(to: view.trailingAnchor)
        tasksContainerView.pinBottom(to: view.bottomAnchor, -10)
        tasksContainerView.layer.cornerRadius = 40.0
        
        tasksTitleLabel.pinTop(to: tasksContainerView.topAnchor, 16)
        tasksTitleLabel.pinLeft(to: tasksContainerView.leadingAnchor, 16)
        
        tasksCollectionView.pinTop(to: tasksTitleLabel.bottomAnchor, 8)
        tasksCollectionView.pinLeft(to: tasksContainerView.leadingAnchor, 16)
        tasksCollectionView.pinRight(to: tasksContainerView.trailingAnchor, 16)
        tasksCollectionView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 16)
    }
    
    private func configureCloseButton() {
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
    }
    
    @objc private func closeButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func monthYearTapped() {
        let alert = UIAlertController(title: "Choose month and year", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
                
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
                
        // Устанавливаем текущий месяц и год как выбранные
        let currentDate = Date()
        let currentMonth = Calendar.current.component(.month, from: currentDate) - 1 // нумерация с 0 для monthNames
        let currentYear = Calendar.current.component(.year, from: currentDate)
        picker.selectRow(currentMonth, inComponent: 0, animated: false)
        if let yearIndex = years.firstIndex(where: { $0 == currentYear }) {
            picker.selectRow(yearIndex, inComponent: 1, animated: false)
        }
                
        picker.frame = CGRect(x: 0, y: 20, width: alert.view.bounds.width - 20, height: 150)
        alert.view.addSubview(picker)
                
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            let selectedMonthIndex = picker.selectedRow(inComponent: 0)
            let selectedYearIndex = picker.selectedRow(inComponent: 1)
            let selectedMonth = selectedMonthIndex + 1 // месяцы в DateComponents начинаются с 1
            let selectedYear = self.years[selectedYearIndex]
                    
            var components = DateComponents()
            components.year = selectedYear
            components.month = selectedMonth
            components.day = 1
            if let selectedDate = Calendar.current.date(from: components) {
                self.interactor?.updateCalendar(to: selectedDate)
            }
        }))
                
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
        present(alert, animated: true)
    }
}

extension CalendarViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2  // 0: месяц, 1: год
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return monthNames.count
        } else {
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return monthNames[row]
        } else {
            return "\(years[row])"
        }
    }
}

extension CalendarViewController: taskCellDelegate {
    func taskCellDidCompleteTask(_ cell: TaskCell) {
        guard let indexPath = tasksCollectionView.indexPath(for: cell) else {
            return
        }
        tasks[indexPath.item].done.toggle()
        cell.updateCompleteButtonAppearance()
        interactor?.updateTask(tasks[indexPath.item])
    }
}
