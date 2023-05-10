//
//  HomeView.swift
//  mvvm-login-app
//
//  Created by KARLOS AGUIRRE on 5/9/23.
//

import Foundation
import UIKit

class HomeView:UIViewController {
    
    private let messageLbl: UILabel = {
        let label = UILabel()
        label.text = "Bienvenido al Home 🥳"
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 40, weight: .bold, width: .standard)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .blue
        view.addSubview(messageLbl)
        NSLayoutConstraint.activate([
            messageLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            messageLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            messageLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
    }
}
