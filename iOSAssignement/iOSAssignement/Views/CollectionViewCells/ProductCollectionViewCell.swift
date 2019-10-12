//
//  ProductCollectionViewCell.swift
//  iOSAssignement
//
//  Created by Иван on 9/30/19.
//  Copyright © 2019 Suprynovich.Technologies. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
    }
    
    // MARK: Configure view
    func configureView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        self.activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: Accessors
    func set(image: UIImage, title: String, subtitle: String) {
        self.imageView.image = image
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }
    
    func showActivityIndicator(show: Bool) {
        show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = !show
    }
    
    // MARK: Other
    class func reuseId() -> String {
        return "ProductCollectionViewCell"
    }
}
