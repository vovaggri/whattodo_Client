import UIKit

final class CalendarViewController: UIViewController {
    enum Constants {
        static let fontName: String = "AoboshiOne-Regular"
    }
    
    var interactor: CalendarInteractorProtocol?
    
    // Данные для отображения
    var weeks: [[CalendarModels.CalendarDay]] = []
    
    private let calendarTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 20)
        label.text = "Calendar"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.fontName, size: 20)
        label.textAlignment = .center
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
        
        navigationItem.titleView = calendarTitle
        setupLayout()
        
        interactor?.fetchCalendar()
    }
    
    func displayCalendar(viewModel: CalendarModels.CalendarViewModel) {
        monthLabel.text = viewModel.title
        self.weeks = viewModel.weeks
        weeksCollectionView.reloadData()
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
        monthLabel.pinCenterX(to: view.centerXAnchor)
        
        daysOfWeekStackView.pinTop(to: monthLabel.bottomAnchor, 16)
        daysOfWeekStackView.pinLeft(to: view.leadingAnchor)
        daysOfWeekStackView.pinRight(to: view.trailingAnchor)
        daysOfWeekStackView.setHeight(30)
        
        weeksCollectionView.pinTop(to: daysOfWeekStackView.bottomAnchor, 8)
        weeksCollectionView.pinLeft(to: view.leadingAnchor)
        weeksCollectionView.pinRight(to: view.trailingAnchor)
        weeksCollectionView.setHeight(60)
    }
}
