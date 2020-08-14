//
//  BugReportViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/14/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class BugReportViewController: UIViewController {

    // MARK: - Properties
    private let topBarView = EditProfileTopBarView(title: "문의/버그신고")
    private let textView = UITextView().then {
        $0.font = UIFont.spoqaHanSansRegular(ofSize: 14)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.vegeLightGrayBorderColor.cgColor
        $0.layer.cornerRadius = 5
    }
    private let sendButton = SignButton(title: "보내기")
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setPropertyAttributes()
        setConstraints()
    }
    
    private func setPropertyAttributes() {
        topBarView.leftBarButton.addTarget(self, action: #selector(handleLeftBarButton(_:)), for: .touchUpInside)
        textView.delegate = self
        textView.becomeFirstResponder()
        sendButton.addTarget(self, action: #selector(handleSendButton(_:)), for: .touchUpInside)
    }
    
    private func setConstraints() {
        [topBarView, textView, sendButton].forEach {
            view.addSubview($0)
        }
        topBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        textView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(250)
        }
        sendButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(textView)
            $0.height.equalTo(48)
        }
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleLeftBarButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func handleSendButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "성공적으로 발송되었습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "확인",
            style: .default,
            handler: { _ in self.dismiss(animated: true, completion: nil) }
        ))
    }
    
}


// MARK: - UITextViewDelegate
extension BugReportViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        sendButton.isActive = textView.text != "" ? true : false
    }
    
}
