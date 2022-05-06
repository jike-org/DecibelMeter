//
//  SettingViewController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 5.05.22.
//

import Foundation
import UIKit


class SettingsView: UIViewController {
    
    lazy var titleLabel = Label(style: .titleLabel, "Settings")
    let cellSpacingHeight: CGFloat = 20
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        
        t.translatesAutoresizingMaskIntoConstraints = false
        
        t.delegate   = self
        t.dataSource = self
        
        t.backgroundColor = .clear
        t.separatorColor  = UIColor(named: "SeparatorColor")
        
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension SettingsView {
    
    private func setupView() {
        view.backgroundColor = .black
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}


// MARK: Table delegate & datasource
extension SettingsView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return cellSpacingHeight
      }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SettingsCell(
            reuseIdentifier: "cell",
            icon: ImageView(image: .documentIcon),
            label: Label(style: .tableLabel, "User agreement"),
            isUsingSwitch: false
        )
        
        switch indexPath.row {
        case 0:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .feedbackIcon),
                label: Label(style: .tableLabel, "FAQ"),
                isUsingSwitch: false
            )
        case 1:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .shareIcon),
                label: Label(style: .tableLabel, "Rate US"),
                isUsingSwitch: false
            )
        case 2:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .privacyIcon),
                label: Label(style: .tableLabel, "Support"),
                isUsingSwitch: false
            )
        case 3:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .documentIcon),
                label: Label(style: .tableLabel, "Privacy Police"),
                isUsingSwitch: false
            )
        case 4:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .playIcon),
                label: Label(style: .tableLabel, "Terms of use"),
                isUsingSwitch: false
            )
        case 5:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .playIcon),
                label: Label(style: .tableLabel, "Share with friends"),
                isUsingSwitch: false
            )
        case 6:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .playIcon),
                label: Label(style: .tableLabel, "Auto-Start on launch"),
                isUsingSwitch: true
            )
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 1:
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 2:
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 3:
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 4:
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 5:
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}


