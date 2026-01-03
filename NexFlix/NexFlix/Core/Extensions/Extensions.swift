//
//  Extensions.swift
//  NexFlix
//
//  Created by Himanshu Dev on 03/01/26.
//

import UIKit

extension UIViewController {
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
