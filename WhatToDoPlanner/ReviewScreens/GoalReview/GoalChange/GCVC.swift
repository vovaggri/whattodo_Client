import UIKit

final class CreateNewGoalViewController: UIViewController, CreateNewGoalDisplayLogic {
  
  var interactor: CreateNewGoalBusinessLogic?
  
  // MARK: UI
    
    let deleteColor = UIColor(hex: "A92424", alpha: 0.6)
  
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
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 35
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.05
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 2
        button.clipsToBounds = false
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
    
    private let taskColorLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Task Color"
        lbl.font = UIFont(name: CreateGoalViewController.fontName, size: 14) ?? UIFont.systemFont(ofSize: 14)
        lbl.textColor = .black
        return lbl
    }()
    
    private let taskColorTextField: UITextField = {
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
        let st = UIStackView(arrangedSubviews: [taskColorLabel, taskColorTextField])
        st.axis = .vertical
        st.spacing = 4
        return st
    }()
    
    private let createGoalButton: UIButton = {
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
      view.backgroundColor = CreateGoalViewController.lightGrayColor
      grayContainerView.backgroundColor = CreateGoalViewController.lightGrayColor
      
      navigationItem.hidesBackButton = true
      
      // Set custom right view for taskColorTextField (color dot + arrow)
      taskColorTextField.rightView = colorRightView
      taskColorTextField.rightViewMode = .always
      
      // Set left padding for text fields (so text is not too close to the border)
      [goalNameTextField, descriptionTextView, taskColorTextField].forEach {
          if let tf = $0 as? UITextField {
              let padding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
              tf.leftView = padding
              tf.leftViewMode = .always
          }
      }
      
      // Add subviews
      view.addSubview(topBarView)
      topBarView.addSubview(backButton)
      topBarView.addSubview(screenTitleLabel)
      
      view.addSubview(grayContainerView)
      grayContainerView.addSubview(taskNameStack)
      
      view.addSubview(whiteContainerView)
      whiteContainerView.addSubview(descriptionStack)
      whiteContainerView.addSubview(colorStack)
      whiteContainerView.addSubview(createGoalButton)
      
      view.addSubview(colorPickerContainer)
    //  colorPickerContainer.addSubview(colorPicker)
      
      setupConstraints()
      
      // Button actions
//      closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
//      createGoalButton.addTarget(self, action: #selector(createGoalButtonTapped), for: .touchUpInside)
//      
//      let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(colorTapped))
//      taskColorTextField.addGestureRecognizer(colorTapGesture)
//    interactor?.loadScreen(request: .init())
  }
  
  private func setupConstraints() {
    // close “x”
      let margin: CGFloat = 16
      
      [
          topBarView, backButton, screenTitleLabel,
          grayContainerView, taskNameStack,
          whiteContainerView, descriptionStack, colorStack, createGoalButton,
          colorPickerContainer,
      ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
      
      NSLayoutConstraint.activate([
          // Top Bar
          topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
          topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          topBarView.heightAnchor.constraint(equalToConstant: 100),
          
         
              backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
              backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
              backButton.widthAnchor.constraint(equalToConstant: 73),
              backButton.heightAnchor.constraint(equalToConstant: 73),
          
          screenTitleLabel.centerYAnchor.constraint(equalTo:backButton.centerYAnchor),
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
          taskColorTextField.heightAnchor.constraint(equalToConstant: 52),
          taskColorTextField.widthAnchor.constraint(equalToConstant: 352),
          taskColorLabel.heightAnchor.constraint(equalToConstant: 52),
          taskColorLabel.widthAnchor.constraint(equalToConstant: 352),
          
          // Create Button in White Container
          createGoalButton.topAnchor.constraint(equalTo: colorStack.bottomAnchor, constant: margin),
          createGoalButton.centerXAnchor.constraint(equalTo: whiteContainerView.centerXAnchor),
          createGoalButton.widthAnchor.constraint(equalToConstant: 352),
          createGoalButton.heightAnchor.constraint(equalToConstant: 50),
          createGoalButton.bottomAnchor.constraint(equalTo: whiteContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -margin),
          
          // Color Picker Container (appears below Task Color field)
          colorPickerContainer.topAnchor.constraint(equalTo: taskColorTextField.bottomAnchor, constant: 4),
          colorPickerContainer.centerXAnchor.constraint(equalTo: taskColorTextField.centerXAnchor),
          colorPickerContainer.widthAnchor.constraint(equalToConstant: 352),
          colorPickerContainer.heightAnchor.constraint(equalToConstant: 75),
          
//          colorPicker.topAnchor.constraint(equalTo: colorPickerContainer.topAnchor),
//          colorPicker.leadingAnchor.constraint(equalTo: colorPickerContainer.leadingAnchor),
//          colorPicker.trailingAnchor.constraint(equalTo: colorPickerContainer.trailingAnchor),
//          colorPicker.bottomAnchor.constraint(equalTo: colorPickerContainer.bottomAnchor),
      ])
     
  }
  
  // MARK: DisplayLogic
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
  
  func displayCreate(viewModel: CreateNewGoalModels.Create.ViewModel) {
    let alert = UIAlertController(
      title: viewModel.alertTitle,
      message: viewModel.alertMessage,
      preferredStyle: .alert
    )
    alert.addAction(.init(title: "OK", style: .default))
    present(alert, animated: true)
  }
  
  // MARK: Actions
  @objc private func dismissSelf() {
    dismiss(animated: true)
  }
  

  

  
  
  /// tiny helper for text entry
  private func presentTextInput(
    title: String,
    initial: String,
    completion: @escaping (String)->Void
  ) {
    let ac = UIAlertController(
      title: title,
      message: nil,
      preferredStyle: .alert
    )
    ac.addTextField { tf in
      tf.text = initial
    }
    ac.addAction(.init(title:"Cancel", style:.cancel))
    ac.addAction(.init(title:"OK", style:.default) { _ in
      completion(ac.textFields?.first?.text ?? "")
    })
    present(ac, animated:true)
  }
}



