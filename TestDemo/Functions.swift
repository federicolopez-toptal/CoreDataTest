//
//  Functions.swift
//  TestDemo
//
//  Created by Federico Lopez on 02/09/2019.
//  Copyright © 2019 Federico Lopez. All rights reserved.
//

import UIKit

// MARK: - String(s)
func BUILD_NEW_TEXT(from: String, inRange range: NSRange, using: String) -> String {
    let stringRange = Range(range, in: from)!
    let newText = from.replacingCharacters(in: stringRange, with: using)
    
    return newText
}

func VALIDATE_ENTRY(_ text: String) -> Bool {
    let regEx = "[<>/:&+%;\"]|\\.\\w{2,4}"
    let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
    return predicate.evaluate(with: text)
}

// MARK: - misc
func ALERT(_ title: String?, _ text: String, viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    viewController.present(alert, animated: true)
}

