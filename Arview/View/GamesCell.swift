//
//  GamesCell.swift
//  Arview
//
//  Created by Zakirov Tahir on 25.04.2021.
//

import UIKit

class GamesCell: UITableViewCell {
    
    
    var nameLabel = UILabel()
    var countChannelsLabel = UILabel()
    var countViewsLabel = UILabel()
    var imageViews = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        let labels = UIStackView(arrangedSubviews: [
            nameLabel, countChannelsLabel, countViewsLabel
        ])
        labels.axis = .vertical
        labels.spacing = 10
        labels.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [
            imageViews, labels
        ])
        stackView.spacing = 10
        
        addSubview(stackView)

        imageViews.constrainWidth(constant: 100)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10))
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
