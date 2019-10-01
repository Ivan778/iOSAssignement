//
//  ISProductsListViewController.swift
//  iOSAssignement
//
//  Created by Иван on 9/30/19.
//  Copyright © 2019 Suprynovich.Technologies. All rights reserved.
//

import UIKit

class ISProductsListViewController: UIViewController {
    @IBOutlet weak var productsListCollectionView: UICollectionView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    // MARK: Configure view
    func configureView() {
        self.configureNavigationController()
        self.configureProductsListCollectionView()
    }
    
    func configureNavigationController() {
        self.title = "products_list_vc_title".localized()
    }
    
    func configureProductsListCollectionView() {
        self.productsListCollectionView.dataSource = self
    }
}

extension ISProductsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
}
