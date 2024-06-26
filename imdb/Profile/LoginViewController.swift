//
//  LoginViewController.swift
//  imdb
//
//  Created by rauan on 1/26/24.
//

import UIKit
import SwiftKeychainWrapper
import Lottie

class LoginViewController: UIViewController {
    var networkManager = NetworkManager.shared
    var emailText: String?
    var passwordText: String?
    var passwordStatus: Bool = true
    let dispatchGroup = DispatchGroup()
    private lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Enter email"
        emailTextField.borderStyle = .roundedRect
        return emailTextField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Enter password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        return passwordTextField
    }()
    
    private lazy var showHidePasswordButton: UIButton = {
        let showHidePasswordButton = UIButton()
        showHidePasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showHidePasswordButton.tintColor = .black
        showHidePasswordButton.addTarget(self, action: #selector(didTogglePassword), for: .touchUpInside)
        showHidePasswordButton.alpha = 0
        return showHidePasswordButton
    }()
    
    private lazy var statusText: UILabel = {
        let statusText = UILabel()
        statusText.text = ""
        return statusText
    }()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .gray
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        self.navigationItem.title = "Log In"
        [emailTextField, passwordTextField, statusText, loginButton, showHidePasswordButton].forEach {
            view.addSubview($0)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.left.right.equalTo(emailTextField)
        }
        showHidePasswordButton.snp.makeConstraints { make in
            make.right.equalTo(passwordTextField.snp.right)
            make.centerY.equalTo(passwordTextField.snp.centerY)
            make.height.equalTo(50)
            make.width.equalTo(70)
        }
        
        statusText.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.left.right.equalTo(emailTextField)
            make.height.greaterThanOrEqualTo(20)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(statusText.snp.bottom).offset(16)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(44)
        }
    }

    @objc
    private func didTogglePassword(){
        passwordStatus = !passwordStatus
        passwordTextField.isSecureTextEntry = passwordStatus
        if passwordStatus {
            showHidePasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            showHidePasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    @objc
    private func didTapLoginButton() {
        emailText = emailTextField.text
        passwordText = passwordTextField.text
        
        guard let emailText, let passwordText else { return }
        dispatchGroup.enter()
        networkManager.getRequestToken { [weak self] result in
            switch result {
            case .success(let dataModel):
                if dataModel.success {
                    let requestData: ValidateAuthenticationModel = .init(username: emailText, password: passwordText, requestToken: dataModel.requestToken)
                    self?.validateWithLogin(with: requestData)
                    self?.dispatchGroup.leave()
                }
            case .failure:
                self?.showAlert(title: "Error", message: "Network connection error")
            }
        }
        dispatchGroup.notify(queue: .main){
            usleep(1100000)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func validateWithLogin(with data: ValidateAuthenticationModel) {
        dispatchGroup.enter()
        networkManager.validateWithLogin(requestBody: data.toDictionary(), completion: { [weak self] result in
            switch result {
            case.success(let dataModel):
                if dataModel.success {
                    if dataModel.success {
                        let requestData = ["request_token": dataModel.requestToken]
                        self?.createSession(with: requestData)
                        self?.dispatchGroup.leave()
                    }
                }
            case .failure:
                self?.showAlert(title: "Error", message: "Could not find login or password")
            }
        })
    }
    
    private func createSession(with requestBody: [String: Any]) {
        dispatchGroup.enter()
        networkManager.createSession(requestBody: requestBody) { [weak self] result in
            
            switch result {
            case .success(let sessionID):
                
                self?.saveSessionID(with: sessionID)
                self?.dispatchGroup.leave()
            case .failure:
                
                self?.showAlert(title: "Cant create session", message: "Something went wrong")
            }
        }
    }
//    aida.moldaly
//    Standartny2020
    
    private func saveSessionID(with sessionID: String) {
        dispatchGroup.enter()
        KeychainWrapper.standard.set(sessionID, forKey: "sessionID")
        let sessionIDValue = KeychainWrapper.standard.set(sessionID, forKey: "sessionID")
        KeychainWrapper.standard.set(emailText!, forKey: "username")
        if sessionIDValue  {
            statusText.text = "Saved successfully"
            statusText.textColor = .green
        } else {
            statusText.text = "Something went wrong"
            statusText.textColor = .red
        }
        dispatchGroup.leave()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        
        }))
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showHidePasswordButton.alpha = 1
    }
}
