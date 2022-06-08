import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"
    
    public func setUp(with viewModel: ProfileViewModel){
        self.textLabel?.text = viewModel.title
        
        switch viewModel.viewModelType {
        case .info:
            self.textLabel?.textAlignment = .center
            self.selectionStyle = .none
        case .logout:
            self.textLabel?.textAlignment = .center
            self.textLabel?.textColor = .red
        case .link:
            self.textLabel?.textAlignment = .center
            self.textLabel?.textColor = .link
        }
    }
}
