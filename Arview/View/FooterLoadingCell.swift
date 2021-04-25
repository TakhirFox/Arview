//
//  FooterLoadingCell.swift
//  Arview
//
//  Created by Zakirov Tahir on 25.04.2021.
//

import UIKit

class FooterLoadingCell: UITableViewHeaderFooterView {
   
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let activityIndicatior = UIActivityIndicatorView(style: .medium)
        activityIndicatior.color = .darkGray
        activityIndicatior.startAnimating()
        
        let loadingLabel = UILabel()
        loadingLabel.text = "Секундочку"
        loadingLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [
            activityIndicatior, loadingLabel
        ])
        
        addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: 200, height: 0))
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
