//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    private var timerLabel: UILabel = {
        let label = UILabel()
        
        label.text = "업무시간"
        label.textAlignment = .center
        
        return label
    }()
    
    private var waitingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "대기중"
        label.textAlignment = .center
        label.backgroundColor = .green
        
        return label
    }()
    
    private var workingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "업무중"
        label.textAlignment = .center
        label.backgroundColor = .blue
        
        return label
    }()
    
    private var addTenCustomersInQueueButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.text = "고객 10명 추가"
        button.addTarget(self, action: #selector(addTenCustomersInQueueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var resetCustomersInQueueButton: UIButton = {
        let button = UIButton()
        
        button.titleLabel?.text = "초기화"
        button.addTarget(self, action: #selector(resetCustomersInQueueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private var statusLabelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private var headerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.axis = .vertical
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
        configureLayout()
    }
    
    private func addSubView() {
        view.addSubview(headerStackView)
        headerStackView.addArrangedSubview(buttonStackView)
        headerStackView.addArrangedSubview(timerLabel)
        headerStackView.addArrangedSubview(statusLabelStackView)
        
        buttonStackView.addArrangedSubview(addTenCustomersInQueueButton)
        buttonStackView.addArrangedSubview(resetCustomersInQueueButton)
        
        statusLabelStackView.addArrangedSubview(waitingLabel)
        statusLabelStackView.addArrangedSubview(workingLabel)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            headerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -500)
                ])


    }
    
    @objc private func addTenCustomersInQueueButtonTapped() {
        print("addTenCustomersInQueueButtonTapped")
    }
    
    @objc private func resetCustomersInQueueButtonTapped() {
        print("resetCustomersInQueueButtonTapped")

    }
}

