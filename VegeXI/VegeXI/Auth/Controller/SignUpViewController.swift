//
//  SignUpViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/4/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    let viewTitle = "회원가입"
    
    private lazy var fakeNavigationBar = FakeNavigationBar(title: viewTitle)
    
    // TextFields
    private lazy var signViewStackView = UIStackView(arrangedSubviews: [idInputView, passwordInputView, retypePasswordInputView, nicknameInputView]).then {
        $0.alignment = .center
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 20
    }
    private let idInputView = SignView(
        placeholder: SignUpStrings.email.generateString(),
        cautionType: .none,
        keyboardType: .emailAddress,
        secureEntry: false
    ).then {
        $0.textField.becomeFirstResponder()
    }
    private let passwordInputView = SignView(
        placeholder: SignUpStrings.password.generateString(),
        cautionType: .none,
        keyboardType: .default,
        secureEntry: true
    )
    
    private let retypePasswordInputView = SignView(
        placeholder: SignUpStrings.retypePassword.generateString(),
        cautionType: .none,
        keyboardType: .default,
        secureEntry: true
    )
    private let nicknameInputView = SignView(
        placeholder: SignUpStrings.nickname.generateString(),
        cautionType: .none,
        keyboardType: .emailAddress,
        secureEntry: false
    )
    
    // Buttons
    private let signUpButton = SignButton(title: GeneralStrings.startButton.generateString())
    private let descriptionLabel = UILabel().then {
        $0.text = SignUpStrings.agreement.generateString()
        $0.font = UIFont.systemFont(ofSize: 10)
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    
    // MARK: - UI
    
    private func configureUI() {
        setPropertyAttribites()
        setConstraints()
    }
    
    private func setPropertyAttribites() {
        [signUpButton].forEach {
            $0.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)
        }
        fakeNavigationBar.leftBarButton.addTarget(self, action: #selector(handlePopAction), for: .touchUpInside)
        
        [idInputView, passwordInputView, retypePasswordInputView, nicknameInputView].forEach {
            $0.textField.delegate = self
        }
    }
    
    private func setConstraints() {
        [fakeNavigationBar, signViewStackView, signUpButton, descriptionLabel].forEach {
            view.addSubview($0)
        }
        
        fakeNavigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        signViewStackView.snp.makeConstraints {
            $0.top.equalTo(fakeNavigationBar.snp.bottom)
            $0.width.equalToSuperview().offset(20)
            $0.height.equalTo(210)
            $0.centerX.equalToSuperview()
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(signViewStackView.snp.bottom).offset(36)
            $0.height.equalTo(48)
            $0.width.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        signViewStackView.arrangedSubviews.forEach {
            $0.snp.makeConstraints {
                $0.width.equalToSuperview().inset(30)
            }
        }
    }
    
    
    // MARK: - Selectors
    @objc private func handlePopAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleButtons(_ sender: UIButton) {
            BasicLoginService.shared.createUser(
                errorHandler: generateErrorMessages(error:),
                email: idInputView.textField.text,
                nickname: nicknameInputView.textField.text,
                password: passwordInputView.textField.text,
                dismiss: self)
    }
    
    
    // MARK: - Helpers

    private func generateErrorMessages(error: Error) {
        switch AuthErrorCode.init(rawValue: error._code) {
        case .invalidEmail:
            let message = SignErrors.invalidEmail.generateErrorMessage()
            showWarnings(view: idInputView, message: message)
        case .emailAlreadyInUse:
            let message = SignErrors.emailAlreadyInUse.generateErrorMessage()
            showWarnings(view: idInputView, message: message)
        case .userNotFound:
            let message = SignErrors.userNotFound.generateErrorMessage()
            showWarnings(view: idInputView, message: message)
        case .wrongPassword:
            let message = SignErrors.wrongPassword.generateErrorMessage()
            showWarnings(view: passwordInputView, message: message)
        case .weakPassword:
            let message = SignErrors.weakPassword.generateErrorMessage()
            showWarnings(view: passwordInputView, message: message)
        default:
            let message = SignErrors.unknown.generateErrorMessage()
            showWarnings(view: passwordInputView, message: message)
            print(error)
        }
    }
    
    private func showWarnings(view: SignView, message: String) {
        view.underBarNeedToTurnRed = true
        view.needToShowWarning = true
        view.cautionMessageLabel.text = message
    }
    
    private func hideWarnings() {
        [idInputView, nicknameInputView, passwordInputView].forEach {
            $0.underBarNeedToTurnRed = false
            $0.needToShowWarning = false
        }
    }
    
    private func checkPassword(password1: String, password2: String) {
        switch password1 == password2 {
        case true:
            retypePasswordInputView.needToShowWarning = false
            retypePasswordInputView.underBarNeedToTurnRed = false
        case false:
            let message = SignErrors.passwordNotMatching.generateErrorMessage()
            showWarnings(view: retypePasswordInputView, message: message)

        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if idInputView.textField.text != ""
            && nicknameInputView.textField.text != ""
            && passwordInputView.textField.text != "" {
            signUpButton.isActive = true
        } else {
            signUpButton.isActive = false
        }
        guard let password1 = passwordInputView.textField.text,
            let password2 = retypePasswordInputView.textField.text,
            password1 != "",
            password2 != "" else { return }
        
      checkPassword(password1: password1, password2: password2)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hideWarnings()
        return true
    }
}
