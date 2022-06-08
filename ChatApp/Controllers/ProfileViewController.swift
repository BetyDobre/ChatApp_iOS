import UIKit
import FirebaseAuth
import GoogleSignIn
import SDWebImage
import WebKit

class ProfileViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var tableView : UITableView!
    
    var data = [ProfileViewModel]()
    
    private var headerView = UIView()

    private var imageView = UIImageView()
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        createProfileTable()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        data = [ProfileViewModel]()
        createProfileTable()
        tableView.reloadData()
        tableView.tableHeaderView = createTableHeader()
    }
    
    func createProfileTable() {
        data.append(ProfileViewModel(viewModelType: .info, title: "Name: \(UserDefaults.standard.value(forKey: "name") as? String ?? "No name")", handler: nil))
        data.append(ProfileViewModel(viewModelType: .info, title: "Email: \(UserDefaults.standard.value(forKey: "email") as? String ?? "No email")", handler: nil))
        data.append(ProfileViewModel(viewModelType: .link, title: "Contact us", handler: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let vc = WKWebViewController()
            strongSelf.present(vc, animated: true)
            
        }))
        data.append(ProfileViewModel(viewModelType: .logout, title: "Log Out", handler: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            let actionSheet = UIAlertController(title: "",
                                            message: "",
                                            preferredStyle: .actionSheet)
        
            actionSheet.addAction(UIAlertAction(title: "Log Out",
                                      style: .destructive,
                                      handler: {[weak self] _ in
                                        
                                        guard let strongSelf = self else {
                                            return
                                        }
                                        
                                        UserDefaults.standard.setValue(nil, forKey: "email")
                                        UserDefaults.standard.setValue(nil, forKey: "name")

                                        // Google log out
                                        GIDSignIn.sharedInstance().signOut()
                                        
                                        do {
                                            try FirebaseAuth.Auth.auth().signOut()
                                            
                                            let vc = LoginViewController()
                                            let nav = UINavigationController(rootViewController: vc)
                                            nav.modalPresentationStyle = .fullScreen
                                            strongSelf.present(nav, animated: true)
                                        }
                                        catch{
                                            print("Failed to log out")
                                        }
                                      }))
            actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
            strongSelf.present(actionSheet, animated: true)
        }))
    }
    
    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(email: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/" + filename
        
        headerView = UIView(frame :CGRect(x: 0, y: 0, width: self.view.width, height: 200))
        imageView = UIImageView(frame: CGRect(x: (headerView.width-150)/2, y: 25, width: 150, height: 150))
        headerView.backgroundColor = .link
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width/2
        headerView.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addPulse))
        tapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        StorageManager.shared.downloadURL(for: path, completion: {result in
            switch result {
            case .success(let url):
                let url2 = URL(string: url)
                self.imageView.sd_setImage(with: url2, completed: nil)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
        
        return headerView
    }
    
    @objc private func addPulse(){
        let point = CGPoint(x:(headerView.width-150)/2 + 75, y: 225)
        let pulse = Pulsing(numberOfPulses: 1, radius: 110, position: point)
        pulse.animationDuration = 0.8
        pulse.backgroundColor = UIColor.blue.cgColor
        
        self.view.layer.insertSublayer(pulse, below: imageView.layer)
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
        cell.setUp(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        data[indexPath.row].handler?()
    }
}
