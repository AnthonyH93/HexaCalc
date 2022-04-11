//
//  SelectionTableViewCell.swift
//  HexaCalc
//
//  Created by Anthony Hopkins on 2022-04-10.
//  Copyright © 2022 Anthony Hopkins. All rights reserved.
//

import UIKit
import SwiftUI

class SelectionSummaryTableViewCell: UITableViewCell {
    
    static let identifier = "SelectionSummaryTableViewCell"

    var rightImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(systemName: "chevron.right")
        return imgView
    }()
    
    var rightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(rightImage)
        addSubview(rightLabel)
        
        rightImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12).isActive = true
        rightImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightLabel.trailingAnchor.constraint(equalTo: rightImage.leadingAnchor, constant: -12).isActive = true
        rightLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
    }
    
    func configure(rightText: String, colour: UIColor) {
        rightLabel.text = rightText
        rightLabel.textColor = colour
        rightImage.tintColor = colour
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
