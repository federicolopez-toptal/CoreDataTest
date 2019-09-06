//
//  UITableViewExtension.swift
//  TestDemo
//
//  Created by Federico Lopez on 02/09/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

extension UITableView {
    
    func deselectAll(delay: TimeInterval) {
        self.perform(#selector(deselect), with: nil, afterDelay: delay)
    }
    
    @objc private func deselect() {
        self.deselectRow(at: self.indexPathForSelectedRow!, animated: true)
    }
    
    func removeEmptyCells() {
        self.tableFooterView = UIView()
    }
    
}
