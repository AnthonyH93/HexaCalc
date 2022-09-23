//
//  CalculationHistoryViewController.swift
//  HexaCalc
//
//  Created by Filippo Zazzeroni on 23/09/22.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import UIKit

class CalculationHistoryViewController: UIViewController {
    
    var calculationHistory: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print(calculationHistory)
    }
    
    

}

extension CalculationHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculationHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calculationHistoryCell", for: indexPath)
        if #available(iOS 14.0, *) {
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = calculationHistory[indexPath.row]
            cell.contentConfiguration = contentConfiguration
        } else {
            cell.textLabel?.text = calculationHistory[indexPath.row]
        }
        
        return cell
    }
    
}
