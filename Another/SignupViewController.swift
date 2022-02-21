//
//  SIgnUpViewController.swift
//  Firebase
//
//  Created by Vincent Cubit on 2/20/22.
//


import UIKit
import FirebaseAuth


final class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    // MARK: UI Subviews
    private let emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        return textField
    }()
    
    
    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.returnKeyType = .go
        return textField
    }()
    
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 20.0
        button.isEnabled = false
        return button
    }()
    
    
    // MARK: Other data
    private var size: CGSize = CGSize(width: 0.0,
                                      height: 0.0)
    private var canProceedWithReturnKey: Bool = false
    
    
    // MARK: Initialization Code
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Sign up"
        self.view.backgroundColor = .systemBackground
        
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        
        
        self.view.addSubview(self.emailField)
        self.view.addSubview(self.passwordField)
        self.view.addSubview(self.loginButton)

        
        self.emailField.addTarget(self, action: #selector(self.checkLength), for: .editingChanged)
        self.passwordField.addTarget(self, action: #selector(self.checkLength), for: .editingChanged)

        
        self.loginButton.addTarget(self,
                                   action: #selector(self.login),
                                   for: .touchUpInside)

        
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        
        self.size = self.view.frame.size


    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.emailField.frame = CGRect(x: 40,
                                       y: self.size.height / 3,
                                       width: self.size.width - 80,
                                       height: 50)
        self.passwordField.frame = CGRect(x: 40,
                                          y: self.emailField.frame.maxY + 30,
                                          width: self.size.width - 80,
                                          height: 50)
        self.loginButton.frame = CGRect(x: 40,
                                        y: self.passwordField.frame.maxY + 30,
                                        width: self.size.width - 80,
                                        height: 50)
        
    }
    
    
    // MARK: Methods
    @objc private func login() {
        
        Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!) { authResult, error in
            if let error = error as NSError? {
            switch AuthErrorCode(rawValue: error.code) {
            case .operationNotAllowed:
              print()
            case .emailAlreadyInUse:
                print()
            case .invalidEmail:
                print()
            case .weakPassword:
                print("Weak password")
            default:
                print("Error: \(error.localizedDescription)")
            }
          } else {
              let alertcontroller = UIAlertController(title: "Congrats!", message: "Signed up", preferredStyle: .alert)
              let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
              alertcontroller.addAction(ok)
              self.present(alertcontroller, animated: true)
          }
        }
        
    }
    
    
    @objc func checkLength() {
        
        if let email = self.emailField.text {
            if let password = self.passwordField.text {
                if email.contains("@") && password.count >= 6 {
                    self.loginButton.backgroundColor = .systemBlue
                    self.loginButton.isEnabled = true
                    self.canProceedWithReturnKey = true
                } else {
                    self.loginButton.backgroundColor = .systemGray
                    self.loginButton.isEnabled = false
                    self.canProceedWithReturnKey = false
                }
            }
        }
        
    }
    
    
    // MARK: TextField Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else {
            if self.canProceedWithReturnKey {
                textField.resignFirstResponder()
                self.login()
            } else {
                print("Show some")
            }
        }
        
        
        return true
        
    }
    

}

