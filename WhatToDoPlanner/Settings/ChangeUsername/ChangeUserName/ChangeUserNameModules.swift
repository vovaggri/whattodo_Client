import Foundation

enum ChangeUsername {
  enum Fetch {
    struct Request { }
    struct Response {
      let firstName: String
      let lastName:  String
    }
    struct ViewModel {
      let firstName: String
      let lastName:  String
    }
  }

  enum Update {
    struct Request {
      let firstName: String
      let lastName:  String
    }
    struct Response {
      let success:      Bool
      let errorMessage: String?
    }
    struct ViewModel {
      let isSuccess:    Bool
      let errorMessage: String?
    }
  }
    
    struct UpdateModelName: Codable {
        let firstName: String
        let secondName: String
        
        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case secondName = "second_name"
        }
    }
    
    struct updateResponse: Decodable {
        let status: String
        
        enum CodingKeys: String, CodingKey {
            case status
        }
    }
}
