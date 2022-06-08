import Foundation
import UIKit

extension UIView{
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var heigth: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.size.height + frame.origin.y
    }
    
    public var left: CGFloat {
        return frame.origin.x

    }
    
    public var right: CGFloat {
        return frame.size.width + frame.origin.x
    }



    public func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }

}

extension Notification.Name{
    //Notification when user logs in
    static let didLogInNotification = Notification.Name("didLogInNotification")
}
