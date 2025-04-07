import UIKit

final class CalendarViewController: UIViewController {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
    }
    
    var interactor: CalendarInteractorProtocol?
    
    // Данные для отображения
    var weeks: [[CalendarModels.CalendarDay]] = []
    
    var selectedDate: Date = Date()
    
    private lazy var monthNames: [String] = {
        return DateFormatter().monthSymbols
    }()
        
    private lazy var years: [Int] = {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array((currentYear - 10)...(currentYear + 10))
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
    
    private lazy var weeksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
                
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true           // Включаем «пэйджинг»
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
                
        cv.dataSource = self
        cv.delegate = self
                
        cv.register(DayCell.self, forCellWithReuseIdentifier: DayCell.Constants.reuseId)
        return cv
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        weeksCollectionView.setHeight(60)
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
