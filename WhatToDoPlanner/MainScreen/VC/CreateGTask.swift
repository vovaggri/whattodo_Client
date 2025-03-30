import UIKit

// MARK: - Protocols

protocol CreateGTaskDisplayLogic: AnyObject {
    func displayTaskData(viewModel: CreateGTask.Fetch.ViewModel)
}

protocol CreateGTaskBusinessLogic {
    func fetchTaskData(request: CreateGTask.Fetch.Request)
}

protocol CreateGTaskPresentationLogic {
    func presentTaskData(response: CreateGTask.Fetch.Response)
    func navigateToTaskDetail()
}


// MARK: - View Controller

final class CreateGTaskViewController: UIViewController, CreateGTaskDisplayLogic {
    
    // MARK: - Custom Font
    static let fontName: String = "AoboshiOne-Regular"
    
    // MARK: - SVIP References
    var interactor: CreateGTaskBusinessLogic?
    
    // MARK: - Data for Picker
    private let colorOptions = ["Aqua Blue", "Moss Green", "Marigold", "Lilac", "Ultra Pink", "Default White"]
    private let colorMap: [String: UIColor] = [
        "Marigold":     UIColor(red: 242/255, green: 233/255, blue: 212/255, alpha: 1.0),
        "Aqua Blue":    UIColor(red: 218/255, green: 236/255, blue: 243/255, alpha: 1.0),
        "Moss Green":   UIColor(red: 232/255, green: 249/255, blue: 228/255, alpha: 1.0),
        "Lilac":        UIColor(red: 223/255, green: 223/255, blue: 244/255, alpha: 1.0),
        "Ultra Pink":   UIColor(red: 252/255, green: 231/255, blue: 255/255, alpha: 1.0),
        "Default White":UIColor(red: 247/255, green: 249/255, blue: 249/255, alpha: 1.0)
    ]
    
    // Background color (F7F9F9)
    static let lightGrayColor = UIColor(red: 247/255, green: 249/255, blue: 249/255, alpha: 1.0)
    
    // MARK: - UI Elements
    
    // Helper: Create tinted icon view
    private func createIconView(image: UIImage) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.black.withAlphaComponent(0.33)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = container.bounds.insetBy(dx: 2, dy: 2)
        container.addSubview(imageView)
        return container
    }
    
    // Color Dot and Right View for Color Field
    private let colorDot: UIView = {
        let dot = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        dot.layer.cornerRadius = 8
        dot.layer.masksToBounds = true
        dot.backgroundColor = .clear
        return dot
    }()
    
    private lazy var colorRightView: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        colorDot.center = CGPoint(x: 8, y: 12)
        container.addSubview(colorDot)
        let arrow = UIImageView(image: UIImage(systemName: "chevron.down"))
        arrow.tintColor = UIColor.black.withAlphaComponent(0.33)
        arrow.contentMode = .scaleAspectFit
        arrow.frame = CGRect(x: 20, y: 4, width: 16, height: 16)
        container.addSubview(arrow)
        return container
    }()
    
    // Top Bar
    private let topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = CreateGTaskViewController.lightGrayColor
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let xImage = UIImage(systemName: "xmark", withConfiguration: config)
        button.setImage(xImage, for: .normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.33)
        return button
    }()
    
    private let screenTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create New Task"
        label.font = UIFont(name: CreateGTaskViewController.fontName, size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // Gray Container (Title and Date)
    private let grayContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = CreateGTaskViewController.lightGrayColor
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Title"
        lbl.font = UIFont(name: CreateGTaskViewController.fontName, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .black
        return lbl
    }()
    
    private let taskNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter task name"
        tf.font = UIFont(name: CreateGTaskViewController.fontName, size: 20)
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 14
        tf.layer.masksToBounds = true
        tf.backgroundColor = .white
        return tf
    }()
    
    private lazy var taskNameStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [titleLabel, taskNameTextField])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Date"
        lbl.font = UIFont(name: CreateGTaskViewController.fontName, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .black
        return lbl
    }()
    
    private let taskDateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "EEE, MMM d, yy"
        tf.font = UIFont(name: CreateGTaskViewController.fontName, size: 20)
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 14
        tf.backgroundColor = .white
        return tf
    }()
    
    private lazy var dateStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [dateLabel, taskDateTextField])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
    
    // Time
    private let startTimeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Start Time"
        lbl.font = UIFont(name: CreateGTaskViewController.fontName, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    private let startTimeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "10:45 AM"
        tf.font = UIFont(name: CreateGTaskViewController.fontName, size: 20)
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 14
        tf.backgroundColor = CreateGTaskViewController.lightGrayColor
        return tf
    }()
    
    private let endTimeLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "End Time"
        lbl.font = UIFont(name: CreateGTaskViewController.fontName, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    private let endTimeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "11:45 AM"
        tf.font = UIFont(name: CreateGTaskViewController.fontName, size: 20)
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 14
        tf.backgroundColor = CreateGTaskViewController.lightGrayColor
        return tf
    }()
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

    
    private lazy var timeStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [startTimeLabel, startTimeTextField, endTimeLabel, endTimeTextField])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
    
    // Task Color
    private let taskColorLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Task Color"
        lbl.font = UIFont(name: CreateGTaskViewController.fontName, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    private let taskColorTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Pick a color"
        tf.font = UIFont(name: CreateGTaskViewController.fontName, size: 20)
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 14
        tf.backgroundColor = CreateGTaskViewController.lightGrayColor
        return tf
    }()
    
    private lazy var colorStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [taskColorLabel, taskColorTextField])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
    
    // Description
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Description"
        lbl.font = UIFont(name: CreateGTaskViewController.fontName, size: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: CreateGTaskViewController.fontName, size: 14)
        tv.layer.cornerRadius = 14
        tv.backgroundColor = CreateGTaskViewController.lightGrayColor
        tv.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        return tv
    }()
    
    private lazy var descriptionStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextView])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
    
    // Create Button
    private let createButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Create Task", for: .normal)
        b.titleLabel?.font = UIFont(name: CreateGTaskViewController.fontName, size: 20)
        b.backgroundColor = .black
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 8
        return b
    }()
    
    // Picker Containers
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
        v.backgroundColor = CreateGTaskViewController.lightGrayColor
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
        v.backgroundColor = CreateGTaskViewController.lightGrayColor
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
        v.backgroundColor = CreateGTaskViewController.lightGrayColor
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CreateGTaskViewController.lightGrayColor
        grayContainerView.backgroundColor = CreateGTaskViewController.lightGrayColor
        
        navigationItem.hidesBackButton = true
        
        // Set right views for text fields
        taskDateTextField.rightView = createIconView(image: UIImage(systemName: "calendar")!)
        taskDateTextField.rightViewMode = .always
        
        startTimeTextField.rightView = createIconView(image: UIImage(systemName: "chevron.down")!)
        startTimeTextField.rightViewMode = .always
        
        endTimeTextField.rightView = createIconView(image: UIImage(systemName: "chevron.down")!)
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
        whiteContainerView.addSubview(createButton)
        
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
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        // Tap gestures for pickers
        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTapped))
        taskDateTextField.addGestureRecognizer(dateTapGesture)
        
        let startTapGesture = UITapGestureRecognizer(target: self, action: #selector(startTimeTapped))
        startTimeTextField.addGestureRecognizer(startTapGesture)
        
        let endTapGesture = UITapGestureRecognizer(target: self, action: #selector(endTimeTapped))
        endTimeTextField.addGestureRecognizer(endTapGesture)
        
        let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
        taskColorTextField.addGestureRecognizer(colorTapGesture)
        
        // Picker targets
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        startTimePicker.addTarget(self, action: #selector(startTimeChanged(_:)), for: .valueChanged)
        endTimePicker.addTarget(self, action: #selector(endTimeChanged(_:)), for: .valueChanged)
        
        // Delegates
        colorPicker.delegate = self
        colorPicker.dataSource = self
        
        let outsideTap = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        outsideTap.cancelsTouchesInView = false
        view.addGestureRecognizer(outsideTap)
        
        interactor?.fetchTaskData(request: CreateGTask.Fetch.Request())
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        let margin: CGFloat = 16
        
        [
            topBarView, closeButton, screenTitleLabel,
            grayContainerView, taskNameStack, dateStack,
            whiteContainerView, descriptionStack, timeStack, colorStack, createButton,
            datePickerContainer, datePicker,
            startTimePickerContainer, startTimePicker,
            endTimePickerContainer, endTimePicker,
            colorPickerContainer, colorPicker
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            // Top Bar
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 60),
            
            closeButton.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor, constant: margin),
            closeButton.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            screenTitleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            screenTitleLabel.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor),
            
            // Gray Container
            grayContainerView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            grayContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayContainerView.heightAnchor.constraint(equalToConstant: 200),
            
            // Task Name Stack in Gray Container
            taskNameStack.topAnchor.constraint(equalTo: grayContainerView.topAnchor, constant: margin),
            taskNameStack.centerXAnchor.constraint(equalTo: grayContainerView.centerXAnchor),
            taskNameTextField.heightAnchor.constraint(equalToConstant: 52),
            taskNameTextField.widthAnchor.constraint(equalToConstant: 352),
            
            // Date Stack in Gray Container
            dateStack.topAnchor.constraint(equalTo: taskNameStack.bottomAnchor, constant: margin),
            dateStack.centerXAnchor.constraint(equalTo: grayContainerView.centerXAnchor),
            taskDateTextField.heightAnchor.constraint(equalToConstant: 52),
            taskDateTextField.widthAnchor.constraint(equalToConstant: 352),
            
            // White Container
            whiteContainerView.topAnchor.constraint(equalTo: grayContainerView.bottomAnchor, constant: 16),
            whiteContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Description Stack in White Container
            descriptionStack.topAnchor.constraint(equalTo: whiteContainerView.topAnchor, constant: 12),
            descriptionStack.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: margin),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 70),
            descriptionTextView.widthAnchor.constraint(equalToConstant: 352),
            
            // Time Stack in White Container
            timeStack.topAnchor.constraint(equalTo: descriptionStack.bottomAnchor, constant: margin),
            timeStack.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: margin),
            timeStack.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -margin),
            
            // Task Color Stack in White Container
            colorStack.topAnchor.constraint(equalTo: timeStack.bottomAnchor, constant: margin),
            colorStack.centerXAnchor.constraint(equalTo: whiteContainerView.centerXAnchor),
            taskColorTextField.heightAnchor.constraint(equalToConstant: 52),
            taskColorTextField.widthAnchor.constraint(equalToConstant: 352),
            
            // Create Button in White Container
            createButton.topAnchor.constraint(equalTo: colorStack.bottomAnchor, constant: 24),
            createButton.leadingAnchor.constraint(equalTo: whiteContainerView.leadingAnchor, constant: margin),
            createButton.trailingAnchor.constraint(equalTo: whiteContainerView.trailingAnchor, constant: -margin),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.bottomAnchor.constraint(equalTo: whiteContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            
            // Date Picker Container
            datePickerContainer.topAnchor.constraint(equalTo: taskDateTextField.bottomAnchor, constant: 4),
            datePickerContainer.leadingAnchor.constraint(equalTo: taskDateTextField.leadingAnchor),
            datePickerContainer.widthAnchor.constraint(equalTo: taskDateTextField.widthAnchor),
            datePickerContainer.heightAnchor.constraint(equalToConstant: 150),
            
            datePicker.topAnchor.constraint(equalTo: datePickerContainer.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor),
            
            // Start Time Picker Container
            startTimePickerContainer.topAnchor.constraint(equalTo: startTimeTextField.bottomAnchor, constant: 4),
            startTimePickerContainer.leadingAnchor.constraint(equalTo: startTimeTextField.leadingAnchor),
            startTimePickerContainer.widthAnchor.constraint(equalToConstant: 180),
            startTimePickerContainer.heightAnchor.constraint(equalToConstant: 150),
            
            startTimePicker.topAnchor.constraint(equalTo: startTimePickerContainer.topAnchor),
            startTimePicker.leadingAnchor.constraint(equalTo: startTimePickerContainer.leadingAnchor),
            startTimePicker.trailingAnchor.constraint(equalTo: startTimePickerContainer.trailingAnchor),
            startTimePicker.bottomAnchor.constraint(equalTo: startTimePickerContainer.bottomAnchor),
            
            // End Time Picker Container
            endTimePickerContainer.topAnchor.constraint(equalTo: endTimeTextField.bottomAnchor, constant: 4),
            endTimePickerContainer.trailingAnchor.constraint(equalTo: endTimeTextField.trailingAnchor),
            endTimePickerContainer.widthAnchor.constraint(equalToConstant: 180),
            endTimePickerContainer.heightAnchor.constraint(equalToConstant: 150),
            
            endTimePicker.topAnchor.constraint(equalTo: endTimePickerContainer.topAnchor),
            endTimePicker.leadingAnchor.constraint(equalTo: endTimePickerContainer.leadingAnchor),
            endTimePicker.trailingAnchor.constraint(equalTo: endTimePickerContainer.trailingAnchor),
            endTimePicker.bottomAnchor.constraint(equalTo: endTimePickerContainer.bottomAnchor),
            
            // Color Picker Container
            colorPickerContainer.topAnchor.constraint(equalTo: taskColorTextField.bottomAnchor, constant: 4),
            colorPickerContainer.leadingAnchor.constraint(equalTo: taskColorTextField.leadingAnchor),
            colorPickerContainer.widthAnchor.constraint(equalTo: taskColorTextField.widthAnchor),
            colorPickerContainer.heightAnchor.constraint(equalToConstant: 75),
            
            colorPicker.topAnchor.constraint(equalTo: colorPickerContainer.topAnchor),
            colorPicker.leadingAnchor.constraint(equalTo: colorPickerContainer.leadingAnchor),
            colorPicker.trailingAnchor.constraint(equalTo: colorPickerContainer.trailingAnchor),
            colorPicker.bottomAnchor.constraint(equalTo: colorPickerContainer.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
//    @objc private func createButtonTapped() {
//        // Navigate to the Task Detail screen when pressing Create button.
//        let taskDetailVC = CreateGTaskAssembly.assembly()
//        self.navigationController?.pushViewController(taskDetailVC, animated: true)
//    }
    
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
    
    // MARK: - Picker Targets
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
    
    // MARK: - Display Logic
    func displayTaskData(viewModel: CreateGTask.Fetch.ViewModel) {
        descriptionTextView.text = viewModel.defaultDescription
    }
    @objc private func createButtonTapped() {
        // Navigate directly to Task Detail screen
        let taskDetailVC = CreateGTaskAssembly.assembly() // Ensure TaskDetailAssembly is implemented
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }

}

// MARK: - UIPickerViewDataSource & Delegate
extension CreateGTaskViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: CreateGTaskViewController.fontName, size: 14)
        label.text = colorOptions[row]
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let chosenColorName = colorOptions[row]
        taskColorTextField.text = chosenColorName
        if let chosenUIColor = colorMap[chosenColorName] {
            self.view.backgroundColor = chosenUIColor
            self.grayContainerView.backgroundColor = chosenUIColor
            self.topBarView.backgroundColor = chosenUIColor
            self.colorDot.backgroundColor = chosenUIColor.withAlphaComponent(1.0)
        }
    }
}
