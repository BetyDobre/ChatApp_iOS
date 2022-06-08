import Foundation

enum ProfileViewModelType {
    case info, logout, link
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}
