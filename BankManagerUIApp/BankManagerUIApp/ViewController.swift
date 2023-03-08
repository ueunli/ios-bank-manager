//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    private var bank = Bank(clerks: .deposit(2), .loan(1))
    
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
    
    private lazy var addTenCustomersInQueueButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("고객 10명 추가", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(addTenCustomersInQueueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var resetCustomersInQueueButton: UIButton = {
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
    
    private var waitingStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private var workingStackView: UIStackView = {
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
        NotificationCenter.default.addObserver(self, selector: #selector(addLabelInWorkingStackView), name: NSNotification.Name("WorkStartNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteLabelFromWorkingStackView), name: NSNotification.Name("WorkFinishedNotification"), object: nil)
    }
    
    @objc func addLabelInWorkingStackView(_ notification: NSNotification) {
        DispatchQueue.main.async {
            let label = UILabel()
            label.text = "\(notification.userInfo!["고객정보"]!)"
            self.workingStackView.addArrangedSubview(label)
        }
    }
    
    @objc func deleteLabelFromWorkingStackView(_ notification: NSNotification) {
        DispatchQueue.main.async {
            let workingStackViewSubViews = self.workingStackView.arrangedSubviews
            let subview = workingStackViewSubViews.filter { subview in
                guard let subview = subview as? UILabel else { return false }
                return subview.text == "\(notification.userInfo!["고객정보"]!)"
            }
            subview[0].removeFromSuperview()
        }
    }
    
    private func addSubView() {
        view.addSubview(headerStackView)
        view.addSubview(scrollView)
        view.addSubview(workingStackView)
        
        headerStackView.addArrangedSubview(buttonStackView)
        headerStackView.addArrangedSubview(timerLabel)
        headerStackView.addArrangedSubview(statusLabelStackView)
        
        scrollView.addSubview(waitingStackView)
        
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
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: waitingLabel.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor )
        ])
        
        waitingStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            waitingStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            waitingStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            waitingStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            waitingStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            waitingStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        workingStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            workingStackView.leadingAnchor.constraint(equalTo: workingLabel.leadingAnchor),
            workingStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            workingStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),
        ])
    }
    
    @objc private func addTenCustomersInQueueButtonTapped() {
        bank.lineUpCustomersInQueue()
        let customerQueue = bank.customers.elements
        var customerHead = customerQueue.head
        for _ in 1...customerQueue.nodeCount {
            let label = UILabel()
            guard let labelText = customerHead?.data else { return }
            label.text = labelText
            waitingStackView.addArrangedSubview(label)
            customerHead = customerHead?.nextNode
        }
        bank.handleAllCustomers()
    }
    
    @objc private func resetCustomersInQueueButtonTapped() {
        print("resetCustomersInQueueButtonTapped")
        waitingStackView.subviews.forEach { $0.removeFromSuperview() }
        workingStackView.subviews.forEach { $0.removeFromSuperview() }
    }
}

