import UIKit

final class ChangeUsernameViewController: UIViewController {
  // MARK: - UI
    
    private let backButton: UIButton = {
        let backButton = UIButton(type: .system)

        // Use SF Symbol arrow
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        backButton.setImage(image, for: .normal)

        backButton.tintColor = .black
        backButton.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        backButton.layer.cornerRadius = 35
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOpacity = 0.05
        backButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        backButton.layer.shadowRadius = 2
        backButton.clipsToBounds = false
        return backButton
    }()
    
  private let titleLabel: UILabel = {
    let lbl = UILabel()
    lbl.text = "Change Username"
    lbl.font = UIFont(name: "AoboshiOne-Regular", size: 28)
    lbl.textAlignment = .center
    return lbl
  }()
    
    private let nameLabel: UILabel = {
      let lbl = UILabel()
      lbl.text = "Name"
      lbl.font = UIFont(name: "AoboshiOne-Regular", size: 14)
      lbl.textColor = .darkGray
      return lbl
    }()

    private let surnameLabel: UILabel = {
      let lbl = UILabel()
      lbl.text = "Surname"
      lbl.font = UIFont(name: "AoboshiOne-Regular", size: 14)
      lbl.textColor = .darkGray
      return lbl
    }()

//  private let firstNameField: UITextField = {
//    let tf = UITextField()
//    tf.placeholder = "First Name"
//      tf.font = UIFont(name: "AoboshiOne-Regular", size: 18)
//   
//    tf.backgroundColor = .white
//      tf.borderStyle = .none
//    tf.layer.cornerRadius = 12
//    tf.layer.shadowColor = UIColor.black.cgColor
//      tf.layer.cornerRadius = 8
//      tf.layer.borderWidth = 1
//      tf.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
//      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 50))
//      tf.leftView = paddingView
//      tf.leftViewMode = .always
//      
//    tf.setHeight( 50 ) // use pin extension or tf.heightAnchor = 50
//    return tf
//  }()
    private let firstNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.font = UIFont(name: "AoboshiOne-Regular", size: 18)
        tf.borderStyle = .none
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 50))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()

    private let lastNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.font = UIFont(name: "AoboshiOne-Regular", size: 18)
        tf.borderStyle = .none
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 50))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    private let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AoboshiOne-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        btn.backgroundColor = UIColor(red: 208/255, green: 232/255, blue: 200/255, alpha: 1.0)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()

  // MARK: - SVIP
  var interactor: ChangeUsernameBusinessLogic?

  // MARK: - Lifecycle
  override func viewDidLoad() {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          tapGesture.cancelsTouchesInView = false
          view.addGestureRecognizer(tapGesture)
      
    super.viewDidLoad()
    view.backgroundColor = .white
      
      saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
      backButton.addTarget(self,
                              action: #selector(backButtonPressed),
                              for: .touchUpInside)

    // “Save” button
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Save",
      style: .done,
      target: self,
      action: #selector(saveTapped)
    )

    setupLayout()
    interactor?.fetchCurrentName(request: .init())
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    
    // MARK: - DisplayLogic
      func displayCurrentName(viewModel: ChangeUsername.Fetch.ViewModel) {
          // pick your font and size
          let font = UIFont(name: "AoboshiOne-Regular", size: 18)
                      ?? UIFont.systemFont(ofSize: 18)
          
          // build attributed strings so the font sticks
          firstNameField.attributedText = NSAttributedString(
              string: viewModel.firstName,
              attributes: [.font: font]
          )
          
          lastNameField.attributedText = NSAttributedString(
              string: viewModel.lastName,
              attributes: [.font: font]
          )
      }
      

    func displayUpdateResult(viewModel: ChangeUsername.Update.ViewModel) {
      if viewModel.isSuccess {
        navigationController?.popViewController(animated: true)
      } else {
        let alert = UIAlertController(
          title: "Error",
          message: viewModel.errorMessage,
          preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
      }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func returnSaveButton() {
        saveButton.isEnabled = true
        saveButton.alpha = 1
    }

  // MARK: - Layout
  private func setupLayout() {
      [ backButton, titleLabel,nameLabel, firstNameField,surnameLabel, lastNameField, saveButton]
      .forEach { view.addSubview($0); $0.translatesAutoresizingMaskIntoConstraints = false }
      backButton.translatesAutoresizingMaskIntoConstraints = false
      backButton
        .pinTop(to: view.safeAreaLayoutGuide.topAnchor, -10)
      backButton
        .pinLeft(to: view, 16)
      backButton
        .setWidth(70)
      backButton
        .setHeight(70)
       

    titleLabel
      .pinTop(to: view.safeAreaLayoutGuide.topAnchor, 50)
    titleLabel.pinCenterX(to: view)
      
      nameLabel
          .pinTop(to: titleLabel.bottomAnchor, 215)
        nameLabel.pinLeft(to: view, 32)

      firstNameField
          .pinTop(to: nameLabel.bottomAnchor, 10)   // top = titleLabel.bottom + 215
      firstNameField
        .pinLeft(to: view, 32)                      // leading = view.leading + 32
      firstNameField
        .pinRight(to: view, 32)                     // trailing = view.trailing – 32
   firstNameField
        .setHeight(50)
      
      surnameLabel
         .pinTop(to: firstNameField.bottomAnchor, 33)
       surnameLabel.pinLeft(to: view, 32)
      
      lastNameField
          .pinTop(to: surnameLabel.bottomAnchor, 10)// top = firstNameField.bottom + 24
      lastNameField
        .pinLeft(to: view, 32)                      // leading = view.leading + 32
      lastNameField
        .pinRight(to: view, 32)                     // trailing = view.trailing – 32
      lastNameField
        .setHeight(50)
      
      saveButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 40)
      saveButton.pinLeft(to: view.leadingAnchor, 48)
      saveButton.pinRight(to: view.trailingAnchor, 48)
      saveButton.setHeight(50)
  }

  // MARK: - Actions
  @objc private func saveTapped() {
      saveButton.isEnabled = false
      saveButton.alpha = 0.5
    let req = ChangeUsername.Update.Request(
      firstName: firstNameField.text ?? "",
      lastName:  lastNameField.text  ?? ""
    )
    interactor?.updateName(request: req)
  }
    
    @objc private func backButtonPressed() {
        if let nav = navigationController {
            // if this VC was pushed
            nav.popViewController(animated: true)
        } else {
            // if this VC was presented modally
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
                let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight = keyboardFrame.height

        // Raise view's elements if the keyboard overlaps the create account button.
        if let surnameFrame = lastNameField.superview?.convert(lastNameField.frame, to: nil) {
            let bottomY = surnameFrame.maxY
            let screenHeight = UIScreen.main.bounds.height
        
            if bottomY > screenHeight - keyboardHeight {
                let overlap = bottomY - (screenHeight - keyboardHeight)
                self.view.frame.origin.y -= overlap + 16
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
