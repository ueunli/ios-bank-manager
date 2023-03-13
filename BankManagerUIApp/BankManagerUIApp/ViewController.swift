//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    private var bank = Bank(clerks: .deposit(2), .loan(1))
    private var waitingCustomerLabels = [Int: Customerlabel]()
    private var processingCustomerLabels = [Int: Customerlabel]()
    
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
    
    private lazy var addTenCustomersButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("고객 10명 추가", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(addTenCustomersInQueueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var resetCustomersButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("초기화", for: .normal)
        button.setTitleColor(.red, for: .normal)
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
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private var waitingCustomersStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private var workingCustomersStackView: UIStackView = {
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
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(addCustomerInWaitingStackView), name: Notification.Name("AddCustomerdInWaitingStackView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(workStart), name: Notification.Name("WorkStart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(workFinished), name: Notification.Name("WorkFinished"), object: nil)
    }
    
    @objc func addCustomerInWaitingStackView(_ notification: Notification) {
        DispatchQueue.main.async {
            guard let customer = notification.userInfo?["고객"] as? Customer else { return }
            let label = Customerlabel(customer: customer)
            self.waitingCustomerLabels.updateValue(label, forKey: customer.number)
            self.waitingCustomersStackView.addArrangedSubview(label)
        }
    }
    
    @objc func workStart(_ notification: Notification) {
        DispatchQueue.main.async {
            guard let customer = notification.userInfo?["고객"] as? Customer else { return }
            guard let label = self.waitingCustomerLabels.removeValue(forKey: customer.number) else { return }
            label.removeFromSuperview()
            self.processingCustomerLabels.updateValue(label, forKey: customer.number)
            self.workingCustomersStackView.addArrangedSubview(label)
        }
    }
    
    @objc func workFinished(_ notification: Notification) {
        DispatchQueue.main.async {
            guard let customer = notification.userInfo?["고객"] as? Customer else { return }
            guard let label = self.processingCustomerLabels.removeValue(forKey: customer.number) else { return }
            label.textColor = .lightGray
            workingCustomersStackView.sendSubviewToBack(label)
        }
    }
    
    private func addSubView() {
        view.addSubview(headerStackView)
        view.addSubview(scrollView)
        view.addSubview(workingCustomersStackView)
        
        headerStackView.addArrangedSubview(buttonStackView)
        headerStackView.addArrangedSubview(timerLabel)
        headerStackView.addArrangedSubview(statusLabelStackView)
        
        scrollView.addSubview(waitingCustomersStackView)
        
        buttonStackView.addArrangedSubview(addTenCustomersButton)
        buttonStackView.addArrangedSubview(resetCustomersButton)
        
        statusLabelStackView.addArrangedSubview(waitingLabel)
        statusLabelStackView.addArrangedSubview(workingLabel)
    }
    
    private func configureUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            headerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerStackView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.25)
        ])
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: waitingLabel.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor )
        ])
        
        waitingCustomersStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            waitingCustomersStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            waitingCustomersStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            waitingCustomersStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            waitingCustomersStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            waitingCustomersStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        workingCustomersStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            workingCustomersStackView.leadingAnchor.constraint(equalTo: workingLabel.leadingAnchor),
            workingCustomersStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            workingCustomersStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),
        ])
    }
    
    // TODO: bank가 일하고 있는 지 확인하여 분기처리 -> 그냥 append VS 작업 시작
    @objc private func addTenCustomersInQueueButtonTapped() {
        //let count = bank.customers.elements.nodeCount
        bank.addMoreCustomers()
    }
    
    @objc private func resetCustomersInQueueButtonTapped() {
        bank.customers.clear()
        waitingCustomerLabels.forEach {
            waitingCustomersStackView.removeArrangedSubview($1)
            //self.waitingCustomerLabels.removeValue(forKey: $0)
        }
        processingCustomerLabels.forEach {
            workingCustomersStackView.removeArrangedSubview($1)
            //self.processingCustomerLabels.removeValue(forKey: $0)
        }
    }
}

