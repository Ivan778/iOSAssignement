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
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    let manager = ISProductsListViewControllerManager()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.loadProductsList()
    }
    
    // MARK: Configure view
    func configureView() {
        self.configureNavigationController()
        self.configureProductsListCollectionView()
    }
    
    func configureProductsListCollectionView() {
        self.productsListCollectionView.dataSource = self
        self.productsListCollectionView.delegate = self
        self.productsListCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.reuseId())
    }
    
    func configure(cell: ProductCollectionViewCell, for indexPath: IndexPath) {
        cell.showActivityIndicator(show: false)
        let product = self.manager.product(for: indexPath)
        cell.set(image: UIImage(), title: product.name, subtitle: "\("price_title".localized()) \(product.price) $")
        if let image = self.manager.image(for: indexPath) {
            cell.imageView.image = image
        } else {
            cell.showActivityIndicator(show: true)
            cell.imageView.setImageFromUrl(ImageURL: product.image) { [weak self] (image) in
                cell.showActivityIndicator(show: false)
                if let cellToUpdate = self?.productsListCollectionView?.cellForItem(at: indexPath) {
                    self?.manager.cache(image: image, indexPath: indexPath)
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5, animations: {
                            cellToUpdate.setNeedsLayout()
                        })
                    }
                }
            }
        }
    }
    
    func configureNavigationController() {
        self.title = "products_list_vc_title".localized()
        self.navigationItem.rightBarButtonItem = self.reloadButton()
    }
    
    func reloadButton() -> UIBarButtonItem {
        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadButtonPressed))
        return reloadButton
    }
    
    // MARK: Handlers
    @objc func reloadButtonPressed() {
        self.loadProductsList()
    }
    
    // MARK: Other
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadProductsList() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.manager.loadProducts(success: { [weak self] () in
            DispatchQueue.main.async {
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                self?.productsListCollectionView.reloadData()
            }
        }) { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                self?.showErrorAlert(title: "error_title".localized(), message: errorMessage)
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension ISProductsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.manager.amountOfProducts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseId(), for: indexPath) as! ProductCollectionViewCell
        self.configure(cell: cell, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = ISProductDetailsViewController(manager: ISProductDetailsViewControllerManager(productId: self.manager.product(for: indexPath).product_id))
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ISProductsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1)
        let availableWidth = self.view.frame.width - paddingSpace
        let widthPerItem = availableWidth / self.itemsPerRow
        let heightPerItem = widthPerItem
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.sectionInsets.left
    }
}
