//
//  OperationStatus.swift
//  BankManagerUIApp
//
//  Created by 김용재 on 2023/03/11.
//

import Foundation

class OperationStatus {
    private(set) var isOpen: Bool
    
    init() {
        self.isOpen = true
    }
    
    func close() {
        isOpen = false
    }
}
