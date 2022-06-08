import Foundation

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    let password: String
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
    
    var safeEmail: String {
        let safeEmail = emailAddress.replacingOccurrences(of: ".", with: ",")
        return safeEmail
    }
}
