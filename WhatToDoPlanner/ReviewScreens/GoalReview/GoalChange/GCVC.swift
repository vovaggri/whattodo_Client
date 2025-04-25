import UIKit

final class ChangeGoalViewController: UIViewController {
  
    var interactor: ChangeGoalBusinessLogic?
    let deleteColor = UIColor(hex: "A92424", alpha: 0.6)
    private let originalGoal: Goal
    private var goal: Goal
  
  // MARK: UI

    private let colorPicker: UIPickerView = {
        let p = UIPickerView()
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    // MARK: - Color Dot and Right View for Color Field
    private let colorDot: UIView = {
        let dot = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        dot.layer.cornerRadius = 8
        dot.layer.masksToBounds = true
        dot.backgroundColor = .clear
        return dot
    }()
    
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
    
    // MARK: - Top Bar
    private let topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = CreateGoalViewController.lightGrayColor
        return view
    }()
    
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
        label.text = "Change Goal"
        label.font = UIFont(name: CreateGoalViewController.fontName, size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Gray Container (for Title)
    private let grayContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = CreateGoalViewController.lightGrayColor
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Title"
        lbl.font = UIFont(name: CreateGoalViewController.fontName, size: 14) ?? UIFont.systemFont(ofSize: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    private let goalNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter goal title"
        tf.font = UIFont(name: CreateGoalViewController.fontName, size: 20)
       // tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 14
        tf.layer.masksToBounds = true
        tf.backgroundColor = .white
        return tf
    }()
    
    private lazy var taskNameStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [titleLabel, goalNameTextField])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
    
    // MARK: - White Container (for Description, Task Color, Create Button)
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
    
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.text = "Description"
        lbl.font = UIFont(name: CreateGoalViewController.fontName, size: 14) ?? UIFont.systemFont(ofSize: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont(name: CreateGoalViewController.fontName, size: 14)
        tv.layer.cornerRadius = 14
        tv.layer.borderWidth = 0.2
        tv.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.33).cgColor
        tv.backgroundColor = CreateGoalViewController.lightGrayColor
        tv.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        return tv
    }()
    
    private lazy var descriptionStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextView])
        st.axis = .vertical
        st.spacing = 1
        return st
    }()
    
    private let goalColorLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Goal Color"
        lbl.font = UIFont(name: CreateGoalViewController.fontName, size: 14) ?? UIFont.systemFont(ofSize: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    private let goalColorTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Pick a color"
        tf.font = UIFont(name: CreateGoalViewController.fontName, size: 20)
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 14
        tf.layer.masksToBounds = true
        tf.borderStyle = .none
        tf.layer.borderWidth = 0
        tf.layer.borderColor = UIColor.clear.cgColor
        tf.backgroundColor = CreateGoalViewController.lightGrayColor
        tf.inputView = UIView()
        return tf
    }()
    
    private lazy var colorStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [goalColorLabel, goalColorTextField])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
    
    private let changeGoalButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Change Goal", for: .normal)
        b.titleLabel?.font = UIFont(name: CreateGoalViewController.fontName, size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        b.backgroundColor = .black
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 8
        return b
    }()
    
    // Color Picker Container (same width as taskColorTextField)
    private let colorPickerContainer: UIView = {
        let v = UIView()
        v.backgroundColor = CreateGoalViewController.lightGrayColor
        v.layer.cornerRadius = 23
        v.layer.borderWidth = 0.4
        v.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.33).cgColor
        v.isHidden = true
        return v
    }()
    
//    private let closeButton: UIButton = {
//            let button = UIButton(type: .system)
//
//            // Use SF Symbol arrow
//            let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
//            let image = UIImage(systemName: "chevron.left", withConfiguration: config)
//            button.setImage(image, for: .normal)
//
//            button.tintColor = .black
//            button.backgroundColor = .white
//            button.layer.cornerRadius = 35
//            button.layer.shadowColor = UIColor.black.cgColor
//            button.layer.shadowOpacity = 0.05
//            button.layer.shadowOffset = CGSize(width: 0, height: 1)
//            button.layer.shadowRadius = 2
//            button.clipsToBounds = false
//            return button
//        }()
    
    private let colorOptions = ["Aqua Blue", "Moss Green", "Marigold", "Lilac", "Ultra Pink", "Default White"]
    private let colorMap: [String: UIColor] = [
        "Marigold":      UIColor(red: 242/255, green: 233/255, blue: 212/255, alpha: 1.0),
        "Aqua Blue":     UIColor(red: 218/255, green: 236/255, blue: 243/255, alpha: 1.0),
        "Moss Green":    UIColor(red: 232/255, green: 249/255, blue: 228/255, alpha: 1.0),
        "Lilac":         UIColor(red: 223/255, green: 223/255, blue: 244/255, alpha: 1.0),
        "Ultra Pink":    UIColor(red: 252/255, green: 231/255, blue: 255/255, alpha: 1.0),
        "Default White": UIColor(red: 247/255, green: 249/255, blue: 249/255, alpha: 1.0)
    ]
    
    init(goal: Goal) {
        self.goal = goal
        self.originalGoal = goal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  override func viewDidLoad() {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          tapGesture.cancelsTouchesInView = false
          view.addGestureRecognizer(tapGesture)
      
    super.viewDidLoad()
      view.backgroundColor = CreateGoalViewController.lightGrayColor
      grayContainerView.backgroundColor = CreateGoalViewController.lightGrayColor
      
      navigationItem.hidesBackButton = true
      
      // Set custom right view for taskColorTextField (color dot + arrow)
      goalColorTextField.rightView = colorRightView
      goalColorTextField.rightViewMode = .always
      
      // Set left padding for text fields (so text is not too close to the border)
      [goalNameTextField, descriptionTextView, goalColorTextField].forEach {
          if let tf = $0 as? UITextField {
              let padding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
              tf.leftView = padding
              tf.leftViewMode = .always
          }
      }
      
      // Add subviews
      view.addSubview(topBarView)
      view.addSubview(closeButton)
      topBarView.addSubview(closeButton)
      topBarView.addSubview(screenTitleLabel)
      
      view.addSubview(grayContainerView)
      grayContainerView.addSubview(taskNameStack)
      
      view.addSubview(whiteContainerView)
      whiteContainerView.addSubview(descriptionStack)
      whiteContainerView.addSubview(colorStack)
      whiteContainerView.addSubview(changeGoalButton)
      
      view.addSubview(colorPickerContainer)
      colorPickerContainer.addSubview(colorPicker)
      
      setupConstraints()
      let colorTap = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
      goalColorTextField.addGestureRecognizer(colorTap)
      goalColorTextField.isUserInteractionEnabled = true
      
        colorPicker.delegate   = self
        colorPicker.dataSource = self

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([
          UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
          UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissPicker))
        ], animated: false)
      
      // Button actions
      closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
     // backButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
      changeGoalButton.addTarget(self, action: #selector(changeGoalButtonTapped), for: .touchUpInside)
      populateFields()
//      createGoalButton.addTarget(self, action: #selector(createGoalButtonTapped), for: .touchUpInside)
//      
//      let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
//      taskColorTextField.addGestureRecognizer(colorTapGesture)
//    interactor?.loadScreen(request: .init())
  }
    
    func displayCreate(viewModel: ChangeGoalModels.Create.ViewModel) {
      let alert = UIAlertController(
        title: viewModel.alertTitle,
        message: viewModel.alertMessage,
        preferredStyle: .alert
      )
      alert.addAction(.init(title: "OK", style: .default))
      present(alert, animated: true)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func populateFields() {
        // 1) title
        goalNameTextField.text = goal.title

        // 2) description
        descriptionTextView.text = goal.description ?? ""

        // 3) colour
        let uiColor = goal.getColour()
        colorDot.backgroundColor = uiColor

        let colorName: String
        switch goal.colour {
        case ColorIDs.aquaBlue: colorName = "Aqua Blue"
        case ColorIDs.mossGreen: colorName = "Moss Green"
        case ColorIDs.marigold: colorName = "Marigold"
        case ColorIDs.lilac: colorName = "Lilac"
        case ColorIDs.ultraPink: colorName = "Ultra Pink"
        case ColorIDs.defaultWhite: colorName = "Default White"
        default: colorName = ""
        }
        goalColorTextField.text = colorName

        colorDot.backgroundColor = uiColor
        view.backgroundColor = uiColor
        grayContainerView.backgroundColor = uiColor
        topBarView.backgroundColor = uiColor
    }
  
  private func setupConstraints() {
    // close “x”
      let margin: CGFloat = 16
      
      [
          topBarView, closeButton, screenTitleLabel,
          grayContainerView, taskNameStack,
          whiteContainerView, descriptionStack, colorStack, changeGoalButton,
          colorPickerContainer,
      ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
      
      NSLayoutConstraint.activate([
          // Top Bar
          topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
          topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          topBarView.heightAnchor.constraint(equalToConstant: 100),
          
         
              closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
              closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
              closeButton.widthAnchor.constraint(equalToConstant: 40),
              closeButton.heightAnchor.constraint(equalToConstant: 40),
          
          
          screenTitleLabel.centerYAnchor.constraint(equalTo:closeButton.centerYAnchor),
          screenTitleLabel.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor),
          
          // Gray Container
          grayContainerView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
          grayContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          grayContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          grayContainerView.heightAnchor.constraint(equalToConstant: 200),
          
          // Task Name Stack in Gray Container
          taskNameStack.topAnchor.constraint(equalTo: grayContainerView.topAnchor, constant: margin),
          taskNameStack.centerXAnchor.constraint(equalTo: grayContainerView.centerXAnchor),
          goalNameTextField.heightAnchor.constraint(equalToConstant: 52),
          goalNameTextField.widthAnchor.constraint(equalToConstant: 352),
          titleLabel.heightAnchor.constraint(equalToConstant: 30),
          
          // White Container
          whiteContainerView.topAnchor.constraint(equalTo: grayContainerView.bottomAnchor, constant: 16),
          whiteContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          whiteContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          whiteContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          
          // Description Stack in White Container
          descriptionStack.topAnchor.constraint(equalTo: whiteContainerView.topAnchor, constant: 8),
          descriptionStack.centerXAnchor.constraint(equalTo: whiteContainerView.centerXAnchor),
          descriptionTextView.heightAnchor.constraint(equalToConstant: 119),
          descriptionTextView.widthAnchor.constraint(equalToConstant: 352),
          descriptionLabel.heightAnchor.constraint(equalToConstant: 52),
          descriptionLabel.widthAnchor.constraint(equalToConstant: 352),
          
          
          // Color Stack in White Container
          colorStack.topAnchor.constraint(equalTo: descriptionStack.bottomAnchor, constant: margin),
          colorStack.centerXAnchor.constraint(equalTo: whiteContainerView.centerXAnchor),
          goalColorTextField.heightAnchor.constraint(equalToConstant: 52),
          goalColorTextField.widthAnchor.constraint(equalToConstant: 352),
          goalColorLabel.heightAnchor.constraint(equalToConstant: 52),
          goalColorLabel.widthAnchor.constraint(equalToConstant: 352),
          
          // Create Button in White Container
          changeGoalButton.topAnchor.constraint(equalTo: colorStack.bottomAnchor, constant: margin),
          changeGoalButton.centerXAnchor.constraint(equalTo: whiteContainerView.centerXAnchor),
          changeGoalButton.widthAnchor.constraint(equalToConstant: 352),
          changeGoalButton.heightAnchor.constraint(equalToConstant: 50),
          changeGoalButton.bottomAnchor.constraint(equalTo: whiteContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
          
          // Color Picker Container (appears below Task Color field)
          colorPickerContainer.topAnchor.constraint(equalTo: goalColorTextField.bottomAnchor, constant: 4),
          colorPickerContainer.centerXAnchor.constraint(equalTo: goalColorTextField.centerXAnchor),
          colorPickerContainer.widthAnchor.constraint(equalToConstant: 352),
          colorPickerContainer.heightAnchor.constraint(equalToConstant: 75),
          
          colorPicker.topAnchor.constraint(equalTo: colorPickerContainer.topAnchor),
          colorPicker.leadingAnchor.constraint(equalTo: colorPickerContainer.leadingAnchor),
          colorPicker.trailingAnchor.constraint(equalTo: colorPickerContainer.trailingAnchor),
          colorPicker.bottomAnchor.constraint(equalTo: colorPickerContainer.bottomAnchor),
      ])
  }
    
    // Temp storage of “entered” text:
      private func createIconView(image: UIImage) -> UIView {
          let container = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
          let imageView = UIImageView(image: image)
          imageView.tintColor = UIColor.black.withAlphaComponent(0.33)
          imageView.contentMode = .scaleAspectFit
          let iconSize: CGFloat = 18
          let offset = (container.bounds.width - iconSize) / 2
          imageView.frame = CGRect(x: offset, y: offset, width: iconSize, height: iconSize)
          container.addSubview(imageView)
          return container
      }
  
  // MARK: DisplayLogic
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
  
  // MARK: Actions
  @objc private func dismissSelf() {
    dismiss(animated: true)
  }
    
    @objc private func dismissPicker() {
      goalColorTextField.resignFirstResponder()
    }
    
    @objc private func colorTapped() {
        colorPickerContainer.isHidden.toggle()
    }

    @objc private func changeGoalButtonTapped() {
        print("Create Goal button tapped")
        guard let goalName = goalNameTextField.text, !goalName.isEmpty else {
            showError(message: "Goal name is required.")
            return
        }
        goal.title = goalName
        
        guard let colorText = goalColorTextField.text, !colorText.isEmpty else {
            showError(message: "Color is required.")
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
        goal.colour = color
        
        let description = descriptionTextView.text
        goal.description = description
        
        if goal == originalGoal {
            showError(message: "Goal wasn't been edited")
            return
        }
        
        interactor?.changeGoal(id: goal.id,title: goalName, description: description ?? "", color: color)
    }
    
    @objc private func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ChangeGoalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return colorOptions.count
  }
  func pickerView(_ pickerView: UIPickerView,
                  viewForRow row: Int,
                  forComponent component: Int,
                  reusing view: UIView?) -> UIView {
    let lbl = (view as? UILabel) ?? UILabel()
    lbl.textAlignment = .center
    lbl.font = UIFont(name: CreateGoalViewController.fontName, size: 14)
    lbl.text = colorOptions[row]
    return lbl
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let name = colorOptions[row]
    goalColorTextField.text = name
    if let uiColor = colorMap[name] {
      colorDot.backgroundColor          = uiColor
      view.backgroundColor              = uiColor
      grayContainerView.backgroundColor = uiColor
      topBarView.backgroundColor        = uiColor
    }
  }
}



