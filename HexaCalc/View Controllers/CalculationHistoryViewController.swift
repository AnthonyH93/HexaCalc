//
//  CalculationHistoryViewController.swift
//  HexaCalc
//
//  Created by Filippo Zazzeroni on 23/09/22.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import UIKit

class CalculationHistoryViewController: UIViewController {
    
    var calculationHistory: [CalculationData] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension CalculationHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculationHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calculationHistoryCell", for: indexPath)
        let operation = calculationHistory[indexPath.row].generateEquation()
        if #available(iOS 14.0, *) {
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.attributedText = NSAttributedString(string: operation, attributes: [.foregroundColor: UIColor.white])
            cell.contentConfiguration = contentConfiguration
        } else {
            cell.textLabel?.textColor = .white
            cell.textLabel?.text = operation
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uiPasteboard = UIPasteboard.general
        uiPasteboard.string = calculationHistory[indexPath.row].result
        
        let alert = UIAlertController(title: "Copied to clipboard", message: "\(calculationHistory[indexPath.row].result) has been added to your clipboard.", preferredStyle: .alert)
        
        present(alert, animated: true) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
}
