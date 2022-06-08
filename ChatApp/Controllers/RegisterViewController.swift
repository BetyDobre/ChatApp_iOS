import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)

    private let scrollView: UIScrollView = {
           let scrollView = UIScrollView()
           scrollView.clipsToBounds = true
           return scrollView
    }()

    private let imageView: UIImageView = {
          let imageView = UIImageView()
          imageView.image = UIImage(systemName: "person.circle")
          imageView.tintColor = .gray
          imageView.contentMode = .scaleAspectFit
          imageView.layer.masksToBounds = true
          imageView.layer.borderWidth = 2
          imageView.layer.borderColor = UIColor.lightGray.cgColor
          return imageView
      }()

    private let firstNameField: UITextField = {
           let field = UITextField()
           field.autocapitalizationType = .none
           field.autocorrectionType = .no
           field.returnKeyType = .continue
           field.layer.cornerRadius = 12
           field.layer.borderWidth = 1
           field.layer.borderColor = UIColor.lightGray.cgColor
           field.placeholder = "First Name..."
           field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
           field.leftViewMode = .always
           field.backgroundColor = .secondarySystemBackground
           return field
    }()

    private let lastNameField: UITextField = {
           let field = UITextField()
           field.autocapitalizationType = .none
           field.autocorrectionType = .no
           field.returnKeyType = .continue
           field.layer.cornerRadius = 12
           field.layer.borderWidth = 1
           field.layer.borderColor = UIColor.lightGray.cgColor
           field.placeholder = "Last Name..."
           field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
           field.leftViewMode = .always
           field.backgroundColor = .secondarySystemBackground
           return field
    }()

    private let emailField: UITextField = {
           let field = UITextField()
           field.autocapitalizationType = .none
           field.autocorrectionType = .no
           field.returnKeyType = .continue
           field.layer.cornerRadius = 12
           field.layer.borderWidth = 1
           field.layer.borderColor = UIColor.lightGray.cgColor
           field.placeholder = "Email Address..."
           field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
           field.leftViewMode = .always
           field.backgroundColor = .secondarySystemBackground
           return field
    }()

    private let passwordField: UITextField = {
           let field = UITextField()
           field.autocapitalizationType = .none
           field.autocorrectionType = .no
           field.returnKeyType = .done
           field.layer.cornerRadius = 12
           field.layer.borderWidth = 1
           field.layer.borderColor = UIColor.lightGray.cgColor
           field.placeholder = "Password..."
           field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
           field.leftViewMode = .always
           field.backgroundColor = .secondarySystemBackground
           field.isSecureTextEntry = true
           return field
    }()

    private let registerButton: UIButton = {
           let button = UIButton()
           button.setTitle("Register", for: .normal)
           button.backgroundColor = .systemGreen
           button.setTitleColor(.white, for: .normal)
           button.layer.cornerRadius = 12
           button.layer.masksToBounds = true
           button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
           return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .done, target: self, action: #selector(didTapLogin))
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(registerButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        registerButton.addTarget(self, action: #selector(registerButtonTaped), for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        gesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(gesture)
    
    }
    
    @objc private func didTapChangeProfilePic(){
        presentPhotoActionSheet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                        y: 20,
                                        width: size,
                                        height: size)

        imageView.layer.cornerRadius = imageView.width/2.0

        firstNameField.frame = CGRect(x: 30,
                                    y: imageView.bottom+10,
                                    width: scrollView.width-60,
                                    height: 52)
        lastNameField.frame = CGRect(x: 30,
                                    y: firstNameField.bottom+10,
                                    width: scrollView.width-60,
                                    height: 52)
        emailField.frame = CGRect(x: 30,
                                    y: lastNameField.bottom+10,
                                    width: scrollView.width-60,
                                    height: 52)
        passwordField.frame = CGRect(x: 30,
                                    y: emailField.bottom+10,
                                    width: scrollView.width-60,
                                    height: 52)
        registerButton.frame = CGRect(x: 30,
                                    y: passwordField.bottom+10,
                                    width: scrollView.width-60,
                                    height: 52)

    }
    
    func alertUserRegisterError(message: String = "Please enter all information to create e new account") {
        let alert = UIAlertController( title: "Error",
                                       message: message,
                                       preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        
    }
        
    @objc private func didTapLogin() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func registerButtonTaped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()

        guard let firstName = firstNameField.text,
                let lastName = lastNameField.text,
                let email = emailField.text,
                let password = passwordField.text,
                !email.isEmpty,
                !password.isEmpty,
                !firstName.isEmpty,
                !lastName.isEmpty,
                password.count >= 6 else {
            alertUserRegisterError()
            return
        
        }
        
        spinner.show(in: view)
        
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard !exists else {
                //user already exists
                strongSelf.alertUserRegisterError(message: "User already exists")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
            
                guard authResult != nil, error == nil else {
                    strongSelf.view.showToast(controller: strongSelf, message : "Error creating user", seconds: 2.0)
                    print("Error creating user")
                    return
                }
            
                UserDefaults.standard.setValue(email, forKey: "email")
                UserDefaults.standard.setValue("\(firstName) \(lastName)", forKey: "name")
                
                print("Created user")
                let user = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email, password: password)
                
                DatabaseManager.shared.insertUser(with: user, completion: {success in
                    if success {
                        //upload image
                        guard let image = strongSelf.imageView.image, let data = image.pngData() else {
                            return
                        }
                        
                        let fileName = user.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                            switch result{
                                case .success(let downloadUrl):
                                    UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                    print(downloadUrl)
                                case .failure(let error):
                                    print("Storage manager error: \(error)")
                            }
                        })
                    }
                })
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                //strongSelf.navigationController?.present(LoginViewController(), animated: true)
            })
    
        })
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            registerButtonTaped()
        }
        
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
            let actionSheet = UIAlertController(title: "Profile Picture",
                                                message: "Would you like to select a picture?",
                                                preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))

            actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                                style: .default,
                                                handler: { [weak self] _ in
                                                    self?.presentPhotoPicker()

            }))

            present(actionSheet, animated: true)
        }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        imageView.image = selectedImage
    }
    
}

