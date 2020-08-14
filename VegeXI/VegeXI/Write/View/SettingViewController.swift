//
//  SettingViewController.swift
//  VegeXI
//
//  Created by Doyoung Song on 8/14/20.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - Properties
    private let topBarView = EditProfileTopBarView(title: SettingViewStrings.barTitle.generateString())
    private let settingTableView = UITableView()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    
    // MARK: - UI
    private func configureUI() {
        setStoredPropertyAttributes()
        setConstraints()
    }
    
    private func setStoredPropertyAttributes() {
        topBarView.leftBarButton.addTarget(self, action: #selector(handleTopBarLeftBarButton(_:)), for: .touchUpInside)
        
        settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        settingTableView.dataSource = self
        settingTableView.delegate = self
        settingTableView.isScrollEnabled = false
        settingTableView.separatorStyle = .none
    }
    
    private func setConstraints() {
        [topBarView, settingTableView].forEach {
            view.addSubview($0)
        }
        topBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        settingTableView.snp.makeConstraints {
            $0.top.equalTo(topBarView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    
    // MARK: - Selectors
    @objc
    private func handleTopBarLeftBarButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    // MARK: - Helpers
    private func configureCellType(cellType: String) -> SettingViewCellType {
        switch cellType {
        case "defualt":
            return .defualt
        case "subtitle":
            return .subtitlte
        case "info":
            return .info
        case "pager":
            return .paging
        case "switcher":
            return .switcher
        default:
            fatalError(cellType)
        }
    }
    
}


// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingCategories.instance.categoryInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = settingTableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { fatalError() }
        guard
            let title = SettingCategories.instance.categoryInfo[indexPath.row]["title"],
            let subtitle = SettingCategories.instance.categoryInfo[indexPath.row]["subtitle"],
            let info = SettingCategories.instance.categoryInfo[indexPath.row]["info"],
            let cellTypeInString = SettingCategories.instance.categoryInfo[indexPath.row]["type"]
            else { fatalError() }
        let cellType = configureCellType(cellType: cellTypeInString)
        
        let lastCellIndex = SettingCategories.instance.categoryInfo.count - 1
        let hideSeparator = indexPath.row == lastCellIndex ? true : false
        cell.configureCell(title: title, subtitle: subtitle, info: info, isOn: false, cellType: cellType, separatorIsHidden: hideSeparator)
        return cell
    }
    
}


// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellTypeInString = SettingCategories.instance.categoryInfo[indexPath.row]["type"] else { fatalError() }
        let cellType = configureCellType(cellType: cellTypeInString)
        switch cellType {
        case .subtitlte:
            return 90
        default:
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let title = SettingCategories.instance.categoryInfo[indexPath.row]["title"] else { return }
        switch title {
        case "비밀번호 변경":
            print(1)
        case "문의/버그신고":
            print(2)
        case "서비스 이용 약관":
            print(3)
        case "개인정보 처리방침":
            print(4)
        default:
            return
        }
    }
    
}
