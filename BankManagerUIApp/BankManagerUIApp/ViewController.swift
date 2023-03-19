//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    private var bank = Bank(clerks: .deposit(2), .loan(1))
    //private var waitingCustomerLabels = [Int: Customerlabel]()
    //private var processingCustomerLabels = [Int: Customerlabel]()
    private var customerLabels = [Int: Customerlabel]()
    
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
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private var waitingCustomersStackView: CustomerStackView = {
        let stackView = CustomerStackView()
        
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.beObserver(about: .add)
        
        return stackView
    }()
    
    private var workingCustomersStackView: CustomerStackView = {
        let stackView = CustomerStackView()
        
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.beObserver(about: .serve)
        stackView.beObserver(about: .remove)

        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
        configureUI()
    }
    
//    @objc func addCustomerInWaitingStackView(_ notification: Notification) {
//        DispatchQueue.main.async {
//            guard let customer = notification.userInfo?["고객"] as? Customer else { return }
//            let label = Customerlabel(customer: customer)
//            self.customerLabels.updateValue(label, forKey: customer.number)
//            self.waitingCustomersStackView.addArrangedSubview(label)
//        }
//    }
//
//    @objc func workStart(_ notification: Notification) {
//        DispatchQueue.main.async {
//            guard let customer = notification.userInfo?["고객"] as? Customer else { return }
//            guard let label = self.customerLabels[customer.number] else { return }
//            label.removeFromSuperview()
//            self.workingCustomersStackView.addArrangedSubview(label)
//        }
//    }
//
//    @objc func workFinished(_ notification: Notification) {
//        DispatchQueue.main.async {
//            guard let customer = notification.userInfo?["고객"] as? Customer else { return }
//            guard let label = self.customerLabels.removeValue(forKey: customer.number) else { return }
//            label.removeFromSuperview()
//        }
//    }
    
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
    
    @objc private func addTenCustomersInQueueButtonTapped() {
        //let count = bank.customers.elements.nodeCount
        bank.addMoreCustomers()
    }
    
    @objc private func resetCustomersInQueueButtonTapped() {
        bank.removeCustomers()
//        waitingCustomerLabels.forEach { index, label in
//            label.removeFromSuperview()
//            self.waitingCustomerLabels.removeValue(forKey: index)
//        }
//        processingCustomerLabels.forEach { index, label in
//            label.removeFromSuperview()
//            self.processingCustomerLabels.removeValue(forKey: index)
//        }
    }
}



//extension CustomerStackView {
//    @objc func addArrangedSubview(notified notification: Notification) {
//        guard let customer = notification.userInfo?["고객"] as? Customer else { return }
//        let label = Customerlabel(customer: customer)
//        self.addArrangedSubview(label)
//        print(#function)
//    }
//
////    @objc func moveArrangedSubview(notified notification: Notification) {
////        guard let customer = notification.userInfo?["고객"] as? Customer,
////              let label = removeCertainSubview(customer) else { return }
////        self.addArrangedSubview(label)
////        print(#function)
////    }
//
//    @objc func removeArrangedSubview(notified notification: Notification) {
//        guard let customer = notification.userInfo?["고객"] as? Customer else { return }
//        self.removeCustomerLabel(customer)
//        print(#function)
//    }
////
//////    func addOnlySubview(_ view: UIView) {
//////        addArrangedSubview(view)
//////    }
////
////    @discardableResult func removeCertainSubview(_ data: Customer) -> Customerlabel? {
////        guard let label = (self.arrangedSubviews.first { ($0 as? Customerlabel)?.customer == data }) else { return nil }
////        self.removeArrangedSubview(label)
////        return label as? Customerlabel
////    }
//}
