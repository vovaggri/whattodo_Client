import UIKit

enum Constants {
    static let fontName: String = "AoboshiOne-Regular"

    // Welcome labels
    static let firstLabelText: String = "Congratulations!"
    static let secondLabelText: String = "You have"
    static let thirdLabelText: String = "successfully"
    static let fourthLabelText: String = "registered to"
    static let fifthLabelText: String = "WhatToDo"
}

final class SuccessScreenViewController: UIViewController {
    var interactor: SuccessScreenBusinessLogic

    private let firstLabel = UILabel()
    private let secondLabel = UILabel()
    private let thirdLabel = UILabel()
    private let fourthLabel = UILabel()
    private let fifthLabel = UILabel()

    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tap to continue", for: .normal)
        button.backgroundColor = UIColor(hex: "#94CA85")?.withAlphaComponent(0.35) ?? UIColor.green.withAlphaComponent(0.35)

        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.fontName, size: 20)
        button.layer.cornerRadius = 14
       

         // **Border (Stroke) - 10% of the button height**
         let buttonHeight: CGFloat = 50
         button.layer.borderWidth = buttonHeight * 0.001 // 10% of height
        button.layer.borderColor = UIColor.green.cgColor

         // **Drop Shadow**
         button.layer.shadowColor = UIColor.green.cgColor
         button.layer.shadowOpacity = 0.2
         button.layer.shadowOffset = CGSize(width: 0, height: 4)
         button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(interactor: SuccessScreenBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        configureWelcomeLabels()
        setupConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animateFifthLabel()
        }

        interactor.fetchSuccessMessage(request: SuccessScreen.SuccessMessage.Request())
    }



    private func setupViews() {
        view.addSubview(continueButton)
    }

    private func configureWelcomeLabels() {
        let labels = [firstLabel, secondLabel, thirdLabel, fourthLabel, fifthLabel]
        for label in labels {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: Constants.fontName, size: 38.5)
            label.textColor = UIColor(hex: "000000")
            view.addSubview(label)
        }

        firstLabel.text = Constants.firstLabelText
        secondLabel.text = Constants.secondLabelText
        thirdLabel.text = Constants.thirdLabelText
        fourthLabel.text = Constants.fourthLabelText
        fifthLabel.text = Constants.fifthLabelText
        
        // Hide fifth label initially
            fifthLabel.alpha = 0
            fifthLabel.text = ""
        

        // Customize the fifth label with colors
        let attributedText = NSMutableAttributedString(string: Constants.fifthLabelText)
        attributedText.addAttribute(.foregroundColor, value: UIColor(hex: "#85B7CA") ?? .blue, range: NSRange(location: 0, length: 4)) // "What"
        attributedText.addAttribute(.foregroundColor, value: UIColor(hex: "#94CA85") ?? .green, range: NSRange(location: 4, length: 2)) // "To"
        attributedText.addAttribute(.foregroundColor, value: UIColor(hex: "#D6C69E") ?? .brown, range: NSRange(location: 6, length: 2)) // "Do"
        fifthLabel.attributedText = attributedText
    }
    private func animateFifthLabel() {
        let text = Constants.fifthLabelText
        let attributedText = NSMutableAttributedString(string: "")

        // Fade in the label before animation
        UIView.animate(withDuration: 0.8) {
            self.fifthLabel.alpha = 1
        }

        var index = 0
        let colors: [NSRange: UIColor] = [
            NSRange(location: 0, length: 4): UIColor(hex: "#85B7CA") ?? .blue, // "What"
            NSRange(location: 4, length: 2): UIColor(hex: "#94CA85") ?? .green, // "To"
            NSRange(location: 6, length: 2): UIColor(hex: "#D6C69E") ?? .brown  // "Do"
        ]

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if index < text.count {
                let char = String(text[text.index(text.startIndex, offsetBy: index)])
                attributedText.append(NSAttributedString(string: char))
                
                // Apply correct color dynamically
                for (range, color) in colors {
                    if range.location <= index && index < range.location + range.length {
                        attributedText.addAttribute(.foregroundColor, value: color, range: NSRange(location: index, length: 1))
                    }
                }

                self.fifthLabel.attributedText = attributedText
                index += 1
            } else {
                timer.invalidate() // Stop when done

                // **Add the dot in black after a short delay**
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    let dot = NSAttributedString(string: ".", attributes: [
                        .foregroundColor: UIColor.black
                    ])
                    attributedText.append(dot)
                    self.fifthLabel.attributedText = attributedText

                    // **Show the button 3 seconds after the animation is done**
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        UIView.animate(withDuration: 0.5) {
                            self.continueButton.alpha = 1
                        }
                    }
                }
            }
        }
    }





    private func setupConstraints() {
        firstLabel.pinTop(to: view, 250)
        firstLabel.pinLeft(to: view, 21)

        secondLabel.pinTop(to: firstLabel, 62)
        secondLabel.pinLeft(to: view, 21)

        thirdLabel.pinTop(to: secondLabel, 62)
        thirdLabel.pinLeft(to: view, 21)

        fourthLabel.pinTop(to: thirdLabel, 62)
        fourthLabel.pinLeft(to: view, 21)

        fifthLabel.pinTop(to: fourthLabel, 62)
        fifthLabel.pinLeft(to: view, 21)

        // **Fix: Add constraints for the button**
        continueButton.pinTop(to: fifthLabel, 445-218)
        continueButton.pinLeft(to: view, 40)
        continueButton.pinRight(to: view, 40)
        continueButton.setHeight(50)
        continueButton.alpha = 0
    }

    func displaySuccessMessage(_ viewModel: SuccessScreen.SuccessMessage.ViewModel) {
        firstLabel.text = viewModel.message
    }
}
