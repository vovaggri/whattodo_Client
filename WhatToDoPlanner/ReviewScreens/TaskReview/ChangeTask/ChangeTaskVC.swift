import UIKit

protocol ChangeTaskViewControllerDelegate: AnyObject {
    func changeTaskViewController(_ viewController: ChangeTaskViewController, didchangeGoal goal: Goal)
}


final class ChangeTaskViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Custom Font
    static let fontName: String = "AoboshiOne-Regular"
    static let fieldsError: String = "Not all necessary fields was filled!"
    
    // MARK: - Properties
    weak var delegate: ChangeTaskViewControllerDelegate?
    var interactor: ChangeTaskBusinessLogic?
    var originalTask: Task?
    var task: Task?
    private var goals: [Goal] = []
    private var selectedGoalId: Int = 0
    
    // For color picker
    private let colorOptions = ["Aqua Blue", "Moss Green", "Marigold", "Lilac", "Ultra Pink", "Default White"]
    
    // For link picker
    private var linkOptions: [String] = ["-"]
    
    // Color map for background updates
    private let colorMap: [String: UIColor] = [
        "Marigold":     UIColor(hex: "F2E9D4") ?? .yellow,
        "Aqua Blue":    UIColor(hex: "DAECF3") ?? .blue,
        "Moss Green":   UIColor(hex: "E8F9E4") ?? .green,
        "Lilac":        UIColor(hex: "DFDFF4") ?? .purple,
        "Ultra Pink":   UIColor(hex: "FCE7FF") ?? .systemPink,
        "Default White": UIColor(hex: "F7F9F9") ?? .white
    ]

    
    // Light-gray color F7F9F9
    static let lightGrayColor = UIColor(
        red: 247.0/255.0,
        green: 249.0/255.0,
        blue: 249.0/255.0,
        alpha: 1.0
    )
    
    // MARK: - Color Dot
    private let colorDot: UIView = {
        let dot = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        dot.layer.cornerRadius = 8
        dot.layer.masksToBounds = true
        dot.backgroundColor = .clear
        return dot
    }()
    
    /// A custom rightView for the color text field (circle + arrow).
    private lazy var colorRightView: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        colorDot.center = CGPoint(x: 10, y: 15)
        container.addSubview(colorDot)
        let arrow = UIImageView(image: UIImage(systemName: "chevron.down"))
        arrow.tintColor = UIColor.black.withAlphaComponent(0.33)
        arrow.contentMode = .scaleAspectFit
        arrow.frame = CGRect(x: 30, y: 5, width: 20, height: 20)
        container.addSubview(arrow)
        return container
    }()
    
    // Link Icon (arrow)
    private lazy var linkIconView: UIView = {
        // narrower container for link arrow
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = UIColor.black.withAlphaComponent(0.33)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 30, y: 5, width: 20, height: 20)
        container.addSubview(imageView)
        return container
    }()
    
    // Reverse map from Int to the string in your colorOptions
    private lazy var colorNameById: [Int:String] = [
        ColorIDs.aquaBlue:    "Aqua Blue",
        ColorIDs.mossGreen:   "Moss Green",
        ColorIDs.marigold:    "Marigold",
        ColorIDs.lilac:       "Lilac",
        ColorIDs.ultraPink:   "Ultra Pink",
        ColorIDs.defaultWhite:"Default White"
    ]
    
    // MARK: - Top bar
    private let topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 247/255, green: 249/255, blue: 249/255, alpha: 1.0)
        return view
    }()
    
    /// A bigger "x" (instead of xmark.circle) with SymbolConfiguration
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        // use xmark, scaled up
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        let xImage = UIImage(systemName: "xmark", withConfiguration: config)
        button.setImage(xImage, for: .normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.33)
        return button
    }()
    
    private let screenTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Change Task"
        label.font = UIFont(name: ChangeTaskViewController.fontName, size: 24)
            ?? UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // Gray container
    private let grayContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = lightGrayColor
        return view
    }()
    
    // Title
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Title"
        lbl.font = UIFont(name: fontName, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .black
        return lbl
    }()
    private let taskNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter task name"
        tf.font = UIFont(name: fontName, size: 20)
        tf.borderStyle = .none
        tf.layer.cornerRadius = 14
        tf.layer.masksToBounds = true
        tf.backgroundColor = .white
        // no border
        tf.layer.borderWidth = 0
        tf.layer.borderColor = UIColor.clear.cgColor
        // left padding of 5 points
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 1))
        tf.leftView = leftPadding
        tf.leftViewMode = .always
        return tf
    }()
    private lazy var taskNameStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [titleLabel, taskNameTextField])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
   
    // Date
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Date"
        lbl.font = UIFont(name: fontName, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .black
        return lbl
    }()
    private let taskDateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "EEE, MMM d, yy"
        tf.font = UIFont(name: fontName, size: 20)
        tf.borderStyle = .none
        tf.layer.cornerRadius = 14
        tf.layer.masksToBounds = true
        tf.backgroundColor = .white
        tf.layer.borderWidth = 0
        tf.layer.borderColor = UIColor.clear.cgColor
        // left padding
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 1))
        tf.leftView = leftPadding
        tf.leftViewMode = .always
        return tf
    }()
    private lazy var calendarIconView: UIView = {
        // Make the container 28 wide and 52 tall (matching your text field height)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 52))
        let iconSize: CGFloat = 18
        // Center the icon within the container
        let offsetX = (container.bounds.width - iconSize) / 2
        let offsetY = (container.bounds.height - iconSize) / 2
        let imageView = UIImageView(frame: CGRect(x: offsetX, y: offsetY, width: iconSize, height: iconSize))
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = UIColor.black.withAlphaComponent(0.33)
        imageView.contentMode = .scaleAspectFit
        container.addSubview(imageView)
        return container
    }()


    private lazy var dateStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [dateLabel, taskDateTextField])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
    
    // White container
    private let whiteContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 35
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.33).cgColor
        return view
    }()
    
    // Description
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Description"
        lbl.font = UIFont(name: fontName, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: fontName, size: 14)
        tv.layer.cornerRadius = 14
        tv.backgroundColor = lightGrayColor
        tv.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        return tv
    }()
    private lazy var descriptionStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextView])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
    
    // Start Time
    private let startTimeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Start Time"
        lbl.font = UIFont(name: fontName, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    private let startTimeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "10:45 AM"
        tf.font = UIFont(name: fontName, size: 20)
        tf.borderStyle = .none
        tf.layer.cornerRadius = 14
        tf.backgroundColor = ChangeTaskViewController.lightGrayColor
        tf.layer.borderWidth = 0
        tf.layer.borderColor = UIColor.clear.cgColor
        // Some left padding
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 1))
        tf.leftView = leftPadding
        tf.leftViewMode = .always
        // Provide a right view (arrow)
        let arrow = UIImageView(image: UIImage(systemName: "chevron.down"))
        arrow.tintColor = UIColor.black.withAlphaComponent(0.33)
        arrow.contentMode = .scaleAspectFit
        arrow.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 24))
        container.addSubview(arrow)
        arrow.center = container.center
        tf.rightView = container
        tf.rightViewMode = .always
        
        return tf
    }()
    private lazy var startTimeIconView: UIView = {
        // narrower container
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = UIColor.black.withAlphaComponent(0.33)
        imageView.contentMode = .scaleAspectFit
        imageView.frame =  CGRect(x: 30, y: 5, width: 20, height: 20)
        container.addSubview(imageView)
        return container
    }()

    private lazy var startTimeStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [startTimeLabel, startTimeTextField])
        st.axis = .vertical
        st.spacing = 2
        return st
    }()
    
    // End Time
    private let endTimeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "End Time"
        lbl.font = UIFont(name: fontName, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    private let endTimeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "11:45 AM"
        tf.font = UIFont(name: fontName, size: 20)
        tf.borderStyle = .none
        tf.layer.cornerRadius = 14
        tf.backgroundColor = ChangeTaskViewController.lightGrayColor
        tf.layer.borderWidth = 0
        tf.layer.borderColor = UIColor.clear.cgColor
        // Some left padding
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 1))
        tf.leftView = leftPadding
        tf.leftViewMode = .always
        // Provide a right view (arrow) - same as start time
        let arrow = UIImageView(image: UIImage(systemName: "chevron.down"))
        arrow.tintColor = UIColor.black.withAlphaComponent(0.33)
        arrow.contentMode = .scaleAspectFit
        arrow.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 24))
        container.addSubview(arrow)
        arrow.center = container.center
        tf.rightView = container
        tf.rightViewMode = .always
        
        return tf
    }()

    private lazy var endTimeIconView: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = UIColor.black.withAlphaComponent(0.33)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 30, y: 5, width: 20, height: 20)
        container.addSubview(imageView)
        return container
    }()
    private lazy var endTimeStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [endTimeLabel, endTimeTextField])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
    private lazy var timeStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [startTimeStack, endTimeStack])
        st.axis = .horizontal
        st.alignment = .top
        st.distribution = .fillEqually // <-- key line
        st.spacing = 16
        return st
    }()

    
    // Link to Goal
//    private let linkLabel: UILabel = {
//        let lbl = UILabel()
//        lbl.text = "Link to Goal"
//        lbl.font = UIFont(name: fontName, size: 14)
//        lbl.textColor = .black
//        return lbl
//    }()
//    private let linkTextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Link to Goal"
//        tf.font = UIFont(name: fontName, size: 20)
//        tf.borderStyle = .none
//        tf.layer.cornerRadius = 14
//        tf.backgroundColor = lightGrayColor
//        // no border
//        tf.layer.borderWidth = 0
//        tf.layer.borderColor = UIColor.clear.cgColor
//        // left padding
//        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 1))
//        tf.leftView = leftPadding
//        tf.leftViewMode = .always
//        tf.inputView = UIView()
//        return tf
//    }()

    
    // Task Color
    private let taskColorLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Task Color"
        lbl.font = UIFont(name: fontName, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    private let taskColorTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Pick a color"
        tf.font = UIFont(name: fontName, size: 20)
        tf.borderStyle = .none
        tf.layer.cornerRadius = 14
        tf.backgroundColor = lightGrayColor
        // no border
        tf.layer.borderWidth = 0
        tf.layer.borderColor = UIColor.clear.cgColor
        // left padding
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 1))
        tf.leftView = leftPadding
        tf.leftViewMode = .always
        tf.inputView = UIView()
        return tf
    }()
    private lazy var colorStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [taskColorLabel, taskColorTextField])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
    
    // change Button
    private let changeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Change Task", for: .normal)
        b.titleLabel?.font = UIFont(name: fontName, size: 20)
        b.backgroundColor = .black
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 8
        return b
    }()
    
    // MARK: - Picker Containers
    private let datePickerContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 14
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.33).cgColor
        v.isHidden = true
        return v
    }()
    private let datePicker: UIDatePicker = {
        let p = UIDatePicker()
        p.datePickerMode = .date
        if #available(iOS 13.4, *) { p.preferredDatePickerStyle = .wheels }
        return p
    }()
    
    private let startTimePickerContainer: UIView = {
        let v = UIView()
        v.backgroundColor = lightGrayColor
        v.layer.cornerRadius = 14
        v.layer.borderWidth = 0.5
        v.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.33).cgColor
        v.isHidden = true
        return v
    }()
    private let startTimePicker: UIDatePicker = {
        let p = UIDatePicker()
        p.datePickerMode = .time
        if #available(iOS 13.4, *) { p.preferredDatePickerStyle = .wheels }
        return p
    }()
    
    private let endTimePickerContainer: UIView = {
        let v = UIView()
        v.backgroundColor = lightGrayColor
        v.layer.cornerRadius = 14
        v.layer.borderWidth = 0.4
        v.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.33).cgColor
        v.isHidden = true
        return v
    }()
    private let endTimePicker: UIDatePicker = {
        let p = UIDatePicker()
        p.datePickerMode = .time
        if #available(iOS 13.4, *) { p.preferredDatePickerStyle = .wheels }
        return p
    }()
    
    private let colorPickerContainer: UIView = {
        let v = UIView()
        v.backgroundColor = lightGrayColor
        v.layer.cornerRadius = 14
        v.layer.borderWidth = 0.4
        v.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.33).cgColor
        v.isHidden = true
        return v
    }()
    private let colorPicker: UIPickerView = {
        let p = UIPickerView()
        return p
    }()
    
//    private let linkPickerContainer: UIView = {
//        let v = UIView()
//        v.backgroundColor = lightGrayColor
//        v.layer.cornerRadius = 14
//        v.layer.borderWidth = 0.4
//        v.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.33).cgColor
//        v.isHidden = true
//        return v
//    }()
//    private let linkPicker: UIPickerView = {
//        let p = UIPickerView()
//        return p
//    }()
    
    // MARK: - Lifecycle
    init(task: Task) {
        self.originalTask = task
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.loadGoals()
        
        view.backgroundColor = ChangeTaskViewController.lightGrayColor
        grayContainerView.backgroundColor = ChangeTaskViewController.lightGrayColor
        
        navigationItem.hidesBackButton = true
        
        // Создаем tap gesture для скрытия клавиатуры
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self  // Устанавливаем делегата
        view.addGestureRecognizer(tapGesture)
        
        
        
        // Set right views
        taskDateTextField.rightView = calendarIconView
        taskDateTextField.rightViewMode = .always
        
        startTimeTextField.rightView = startTimeIconView
        startTimeTextField.rightViewMode = .always
        
        endTimeTextField.rightView = endTimeIconView
        endTimeTextField.rightViewMode = .always
        
        taskColorTextField.rightView = colorRightView
        taskColorTextField.rightViewMode = .always
        
        // Add subviews
        view.addSubview(topBarView)
        topBarView.addSubview(closeButton)
        topBarView.addSubview(screenTitleLabel)
        
        view.addSubview(grayContainerView)
        grayContainerView.addSubview(taskNameStack)
        grayContainerView.addSubview(dateStack)
        
        view.addSubview(whiteContainerView)
        whiteContainerView.addSubview(descriptionStack)
        whiteContainerView.addSubview(timeStack)
        whiteContainerView.addSubview(colorStack)
        whiteContainerView.addSubview(changeButton)
        
        // Picker containers
        view.addSubview(datePickerContainer)
        datePickerContainer.addSubview(datePicker)
        
        view.addSubview(startTimePickerContainer)
        startTimePickerContainer.addSubview(startTimePicker)
        
        view.addSubview(endTimePickerContainer)
        endTimePickerContainer.addSubview(endTimePicker)
        
        view.addSubview(colorPickerContainer)
        colorPickerContainer.addSubview(colorPicker)
        
        setupConstraints()
        
        // Button actions
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        
        // Tap gestures for pickers
        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTapped))
        taskDateTextField.addGestureRecognizer(dateTapGesture)
        
        let startTapGesture = UITapGestureRecognizer(target: self, action: #selector(startTimeTapped))
        startTimeTextField.addGestureRecognizer(startTapGesture)
        
        let endTapGesture = UITapGestureRecognizer(target: self, action: #selector(endTimeTapped))
        endTimeTextField.addGestureRecognizer(endTapGesture)
        
        let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
        taskColorTextField.addGestureRecognizer(colorTapGesture)
        
        // Picker changes
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        startTimePicker.addTarget(self, action: #selector(startTimeChanged(_:)), for: .valueChanged)
        endTimePicker.addTarget(self, action: #selector(endTimeChanged(_:)), for: .valueChanged)
        
        // Delegates
        colorPicker.delegate = self
        colorPicker.dataSource = self
        
        // Если требуется второй жест (например, для закрытия pickers)
        let outsideTap = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        outsideTap.cancelsTouchesInView = false
        outsideTap.delegate = self  // Устанавливаем делегата и для второго жеста
        view.addGestureRecognizer(outsideTap)
        
        populateFields()
    }
    
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func displayTaskUpload(viewModel: ChangeTaskModels.ViewModel) {
        let alert = UIAlertController(title: nil, message: viewModel.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // Метод делегата для разрешения одновременного распознавания
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func showGoals(with goals: [Goal]) {
        self.goals = goals
        
//        self.linkOptions = ["-"] + goals.map { $0.title }
//        linkPicker.reloadAllComponents()
//        
//        // If this task already has a goalId, pre-select it:
//        if let gid = task?.goalId,
//            let goalIndex = goals.firstIndex(where: { $0.id == gid }) {
//            let pickerRow = goalIndex + 1        // +1 because linkOptions[0] == "-"
//            linkTextField.text = goals[goalIndex].title
//            linkPicker.selectRow(pickerRow, inComponent: 0, animated: false)
//            selectedGoalId = gid
//        } else {
//            // no goal linked yet
//            linkTextField.text = "-"
//            linkPicker.selectRow(0, inComponent: 0, animated: false)
//            selectedGoalId = 0
//        }
    }
    
    // MARK: - Helper: change tinted icon in a smaller container
    private func changeIconView(image: UIImage) -> UIView {
        // narrower container than before, so icon is more centered
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.black.withAlphaComponent(0.33)
        imageView.contentMode = .scaleAspectFit
        // a bit more insetting
        imageView.frame = container.bounds.insetBy(dx: 2, dy: 2)
        container.addSubview(imageView)
        return container
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        let margin: CGFloat = 16
        
        [
            topBarView, closeButton, screenTitleLabel,
            grayContainerView, taskNameStack, dateStack,
            whiteContainerView, descriptionStack, timeStack, colorStack, changeButton,
            datePickerContainer, datePicker,
            startTimePickerContainer, startTimePicker,
            endTimePickerContainer, endTimePicker,
            colorPickerContainer, colorPicker
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            // Top bar
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 60),
            
            // The bigger 'x' button
            closeButton.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor, constant: margin),
            closeButton.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 40),   // a bit bigger
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            screenTitleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            screenTitleLabel.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor),
            
            // Gray container
            grayContainerView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            grayContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayContainerView.heightAnchor.constraint(equalToConstant: 200),
            
            // Title
            taskNameStack.topAnchor.constraint(equalTo: grayContainerView.topAnchor, constant: margin),
            taskNameStack.centerXAnchor.constraint(equalTo: grayContainerView.centerXAnchor),
            taskNameTextField.heightAnchor.constraint(equalToConstant: 52),
            taskNameTextField.widthAnchor.constraint(equalToConstant: 352),
            
            // Date
            dateStack.topAnchor.constraint(equalTo: taskNameStack.bottomAnchor, constant: margin),
            dateStack.centerXAnchor.constraint(equalTo: grayContainerView.centerXAnchor),
            taskDateTextField.heightAnchor.constraint(equalToConstant: 52),
            taskDateTextField.widthAnchor.constraint(equalToConstant: 352),
            
            // White container
            whiteContainerView.topAnchor.constraint(equalTo: grayContainerView.bottomAnchor, constant: 16),
            whiteContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Description
            descriptionStack.topAnchor.constraint(equalTo: whiteContainerView.topAnchor, constant: 12),
            descriptionStack.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: margin),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
            descriptionTextView.widthAnchor.constraint(equalToConstant: 352),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 22),
            
            
            // Time
            timeStack.topAnchor.constraint(equalTo: descriptionStack.bottomAnchor, constant: margin),
            timeStack.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: margin),
            timeStack.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -margin),
            timeStack.heightAnchor.constraint(equalToConstant: 60),
            endTimeLabel.widthAnchor.constraint(equalToConstant: 160),
            startTimeLabel.widthAnchor.constraint(equalToConstant: 160),
            startTimeTextField.widthAnchor.constraint(equalToConstant: 160),
            endTimeTextField.widthAnchor.constraint(equalToConstant: 160),
            startTimeTextField.heightAnchor.constraint(equalToConstant: 44),
            endTimeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Task Color
            colorStack.topAnchor.constraint(equalTo: timeStack.bottomAnchor, constant: margin),
            colorStack.centerXAnchor.constraint(equalTo: whiteContainerView.centerXAnchor),
            taskColorTextField.heightAnchor.constraint(equalToConstant: 52),
            taskColorTextField.widthAnchor.constraint(equalToConstant: 352),
            taskColorLabel.heightAnchor.constraint(equalToConstant: 22),
            // change button
            changeButton.topAnchor.constraint(equalTo: colorStack.bottomAnchor, constant: 24),
            changeButton.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: margin),
            changeButton.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -margin),
            changeButton.heightAnchor.constraint(equalToConstant: 50),
            changeButton.bottomAnchor.constraint(equalTo: whiteContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            
            // Date picker
            datePickerContainer.topAnchor.constraint(equalTo: taskDateTextField.bottomAnchor, constant: 4),
            datePickerContainer.leadingAnchor.constraint(equalTo: taskDateTextField.leadingAnchor),
            datePickerContainer.widthAnchor.constraint(equalTo: taskDateTextField.widthAnchor),
            datePickerContainer.heightAnchor.constraint(equalToConstant: 150),
            
            datePicker.topAnchor.constraint(equalTo: datePickerContainer.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor),
            
            // Start time picker
            startTimePickerContainer.topAnchor.constraint(equalTo: startTimeTextField.bottomAnchor, constant: 4),
            startTimePickerContainer.leadingAnchor.constraint(equalTo: startTimeTextField.leadingAnchor),
            startTimePickerContainer.widthAnchor.constraint(equalToConstant: 180),
            startTimePickerContainer.heightAnchor.constraint(equalToConstant: 150),
            
            startTimePicker.topAnchor.constraint(equalTo: startTimePickerContainer.topAnchor),
            startTimePicker.leadingAnchor.constraint(equalTo: startTimePickerContainer.leadingAnchor),
            startTimePicker.trailingAnchor.constraint(equalTo: startTimePickerContainer.trailingAnchor),
            startTimePicker.bottomAnchor.constraint(equalTo: startTimePickerContainer.bottomAnchor),
            
            // End time picker
            endTimePickerContainer.topAnchor.constraint(equalTo: endTimeTextField.bottomAnchor, constant: 4),
            endTimePickerContainer.trailingAnchor.constraint(equalTo: endTimeTextField.trailingAnchor),
            endTimePickerContainer.widthAnchor.constraint(equalToConstant: 180),
            endTimePickerContainer.heightAnchor.constraint(equalToConstant: 150),
            
            endTimePicker.topAnchor.constraint(equalTo: endTimePickerContainer.topAnchor),
            endTimePicker.leadingAnchor.constraint(equalTo: endTimePickerContainer.leadingAnchor),
            endTimePicker.trailingAnchor.constraint(equalTo: endTimePickerContainer.trailingAnchor),
            endTimePicker.bottomAnchor.constraint(equalTo: endTimePickerContainer.bottomAnchor),
            
            // Color picker
            colorPickerContainer.topAnchor.constraint(equalTo: taskColorTextField.bottomAnchor, constant: 4),
            colorPickerContainer.leadingAnchor.constraint(equalTo: taskColorTextField.leadingAnchor),
            colorPickerContainer.widthAnchor.constraint(equalTo: taskColorTextField.widthAnchor),
            colorPickerContainer.heightAnchor.constraint(equalToConstant: 75),
            
            colorPicker.topAnchor.constraint(equalTo: colorPickerContainer.topAnchor),
            colorPicker.leadingAnchor.constraint(equalTo: colorPickerContainer.leadingAnchor),
            colorPicker.trailingAnchor.constraint(equalTo: colorPickerContainer.trailingAnchor),
            colorPicker.bottomAnchor.constraint(equalTo: colorPickerContainer.bottomAnchor),
            
//            // Link picker
//            linkPickerContainer.topAnchor.constraint(equalTo: linkTextField.bottomAnchor, constant: 4),
//            linkPickerContainer.leadingAnchor.constraint(equalTo: linkTextField.leadingAnchor),
//            linkPickerContainer.widthAnchor.constraint(equalTo: linkTextField.widthAnchor),
//            linkPickerContainer.heightAnchor.constraint(equalToConstant: 75),
            
//            linkPicker.topAnchor.constraint(equalTo: linkPickerContainer.topAnchor),
//            linkPicker.leadingAnchor.constraint(equalTo: linkPickerContainer.leadingAnchor),
//            linkPicker.trailingAnchor.constraint(equalTo: linkPickerContainer.trailingAnchor),
//            linkPicker.bottomAnchor.constraint(equalTo: linkPickerContainer.bottomAnchor),
        ])
    }
    
    private func populateFields() {
        guard let task = task else { return }

        // 1. Title
        taskNameTextField.text = task.title

        // 2. Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yy"
        taskDateTextField.text = dateFormatter.string(from: task.endDate)
        datePicker.date = task.endDate
        
        if task.startTime != task.endTime {
            // 3. Start Time (if any)
            if let start = task.startTime {
                let tf = DateFormatter()
                tf.dateFormat = "hh:mm a"
                startTimeTextField.text = tf.string(from: start)
                startTimePicker.date = start
            }

            // 4. End Time (if any)
            if let end = task.endTime {
                let tf = DateFormatter()
                tf.dateFormat = "hh:mm a"
                endTimeTextField.text = tf.string(from: end)
                endTimePicker.date = end
            }
        }

        // 5. Description
        descriptionTextView.text = task.description

        // 6. Color
        if let name = colorNameById[task.colour] {
            taskColorTextField.text = name
            colorDot.backgroundColor = task.getColour()
            // also tint your containers if you want:
            let bg = task.getColour()
            view.backgroundColor = bg
            grayContainerView.backgroundColor = bg
            topBarView.backgroundColor = bg
        }

//        // 7. (Optional) Link to Goal
//        if let gid = task.goalId {
//            linkTextField.text = "Goal \(gid)"
//            // you could also select the right row in your linkPicker here
//        }
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func changeButtonTapped() {
        guard let taskName = taskNameTextField.text, !taskName.isEmpty else {
            print("Task name is required.")
            showError(message: CreateTaskViewController.fieldsError)
            return
        }
        task?.title = taskName
        
        guard let dateText = taskDateTextField.text, !dateText.isEmpty else {
            print("Date is required.")
            showError(message: CreateTaskViewController.fieldsError)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = dateFormatter.date(from: dateText) else {
            showError(message: CreateTaskViewController.fieldsError)
            return
        }
        task?.endDate = date
        
        var startTime: Date?
        if let startTimeText = startTimeTextField.text, !startTimeText.isEmpty {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
                
            guard let parsedStartTime = timeFormatter.date(from: startTimeText) else {
                showError(message: "Incorrect format")
                return
            }
            startTime = parsedStartTime
        }
        
        var endTime: Date?
        if let endTimeText = endTimeTextField.text, !endTimeText.isEmpty {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            
            guard let parsedEndTime = timeFormatter.date(from: endTimeText) else {
                showError(message: "Incorrect format")
                return
            }
            endTime = parsedEndTime
        }
        if startTime != endTime {
            task?.startTime = startTime
            task?.endTime = endTime
        }
        
        if (startTime == nil && endTime != nil) || (startTime != nil && endTime == nil) {
            showError(message: "Both start time and end time must be provided, or none at all.")
            return
        }
        
        if let start = startTime, let end = endTime, start > end {
            showError(message: "Start time cannot be later than end time.")
            return
        }
        
        guard let colorText = taskColorTextField.text, !colorText.isEmpty else {
            print("Color is required")
            showError(message: CreateTaskViewController.fieldsError)
            return
        }
        
        var color: Int
        
        if colorText == "Aqua Blue" {
            color = ColorIDs.aquaBlue
        } else if colorText == "Moss Green" {
            color = ColorIDs.mossGreen
        } else if colorText == "Marigold" {
            color = ColorIDs.marigold
        } else if colorText == "Lilac" {
            color = ColorIDs.lilac
        } else if colorText == "Ultra Pink" {
            color = ColorIDs.ultraPink
        } else if colorText == "Default White" {
            color = ColorIDs.defaultWhite
        } else {
            print("Unknown color")
            return
        }
        task?.colour = color
        
        let description = descriptionTextView.text
        task?.description = description
        let goalId: Int = selectedGoalId
        task?.goalId = selectedGoalId
        
        if task == originalTask {
            showError(message: "Task wasn't be edited.")
        }

        interactor?.updateTask(id: task?.id ?? 0,title: taskName, date: date, color: color, description: description, startTime: startTime, endTime: endTime, goalId: goalId)
    }
    
    @objc private func dateTapped() {
        datePickerContainer.isHidden.toggle()
        startTimePickerContainer.isHidden = true
        endTimePickerContainer.isHidden = true
        colorPickerContainer.isHidden = true
    }
    @objc private func startTimeTapped() {
        startTimePickerContainer.isHidden.toggle()
        endTimePickerContainer.isHidden = true
        colorPickerContainer.isHidden = true
        datePickerContainer.isHidden = true
    }
    @objc private func endTimeTapped() {
        endTimePickerContainer.isHidden.toggle()
        startTimePickerContainer.isHidden = true
        colorPickerContainer.isHidden = true
        datePickerContainer.isHidden = true
    }
    @objc private func colorTapped() {
        colorPickerContainer.isHidden.toggle()
        startTimePickerContainer.isHidden = true
        endTimePickerContainer.isHidden = true
        datePickerContainer.isHidden = true
    }
    @objc private func linkTapped() {
        datePickerContainer.isHidden = true
        startTimePickerContainer.isHidden = true
        endTimePickerContainer.isHidden = true
        colorPickerContainer.isHidden = true
    }
    
    @objc private func dateChanged(_ picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yy"
        taskDateTextField.text = formatter.string(from: picker.date)
    }
    @objc private func startTimeChanged(_ picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        startTimeTextField.text = formatter.string(from: picker.date)
    }
    @objc private func endTimeChanged(_ picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        endTimeTextField.text = formatter.string(from: picker.date)
    }
    
    @objc private func handleOutsideTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !datePickerContainer.frame.contains(location),
           !startTimePickerContainer.frame.contains(location),
           !endTimePickerContainer.frame.contains(location),
           !colorPickerContainer.frame.contains(location),
           !taskDateTextField.frame.contains(location),
           !startTimeTextField.frame.contains(location),
           !endTimeTextField.frame.contains(location),
           !taskColorTextField.frame.contains(location) {
            
            datePickerContainer.isHidden = true
            startTimePickerContainer.isHidden = true
            endTimePickerContainer.isHidden = true
            colorPickerContainer.isHidden = true
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UIPickerViewDataSource & Delegate
extension ChangeTaskViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == colorPicker {
            return colorOptions.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: ChangeTaskViewController.fontName, size: 14)
        if pickerView == colorPicker {
            label.text = colorOptions[row]
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if pickerView == colorPicker {
            let chosenColorName = colorOptions[row]
            taskColorTextField.text = chosenColorName
            if let chosenUIColor = colorMap[chosenColorName] {
                self.view.backgroundColor = chosenUIColor
                self.grayContainerView.backgroundColor = chosenUIColor
                self.topBarView.backgroundColor = chosenUIColor
                colorDot.backgroundColor = chosenUIColor.withAlphaComponent(1.0)
            }
        }
    }
}
