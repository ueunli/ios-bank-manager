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
        let button = UIButton()
        
        button.titleLabel?.text = "고객 10명 추가"
        button.addTarget(ViewController.self, action: #selector(addTenCustomersInQueueButtonTapped), for: .touchUpInside)
        button.titleLabel?.textColor = .blue
        return button
    }()
    
    private var resetCustomersInQueueButton: UIButton = {
        let button = UIButton()
        
        button.titleLabel?.text = "초기화"
        button.addTarget(ViewController.self, action: #selector(resetCustomersInQueueButtonTapped), for: .touchUpInside)
        button.titleLabel?.textColor = .red
        return button
    }()
    
    private var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private var statusLabelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private var headerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.axis = .vertical
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc private func addTenCustomersInQueueButtonTapped() {
        
    }
    
    @objc private func resetCustomersInQueueButtonTapped() {
        
    }
}

