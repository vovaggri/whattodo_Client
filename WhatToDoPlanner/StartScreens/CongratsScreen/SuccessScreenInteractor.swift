import UIKit

protocol SuccessScreenBusinessLogic {
    func fetchSuccessMessage(request: SuccessScreen.SuccessMessage.Request)
    func continueButtonLogic()
}

class SuccessScreenInteractor: SuccessScreenBusinessLogic {
    var presenter: SuccessScreenPresentationLogic?
    
    func fetchSuccessMessage(request: SuccessScreen.SuccessMessage.Request) {
        let response = SuccessScreen.SuccessMessage.Response(message: "Congratulations!\nYou have successfully registered to WhatToDo.")
        presenter?.presentSuccessMessage(response: response)
    }
    
    func continueButtonLogic() {
        presenter?.navigateToMainScreen()
    }
}


