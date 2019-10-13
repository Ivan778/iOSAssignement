//
//  ISProductDetailsViewController.swift
//  iOSAssignement
//
//  Created by Иван on 10/13/19.
//  Copyright © 2019 Suprynovich.Technologies. All rights reserved.
//

import UIKit

class ISProductDetailsViewController: UIViewController {
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageViewContainerWidthConstraint: UIView!
    @IBOutlet weak var imageViewContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var contentContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var productActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    private var manager: ISProductDetailsViewControllerManager!
    
    // MARK: Init
    convenience init(manager: ISProductDetailsViewControllerManager) {
        self.init()
        self.manager = manager
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.loadProductDetails()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        UIView.animate(withDuration: 0.3) {
            self.resizeTableViewContainer()
            self.view.layoutIfNeeded()
        }
    }

    // MARK: Configure view
    func configureView() {
        self.configureNavigationController()
        self.configureImageViewContainer()
        self.configureContentTableView()
    }
    
    func configureImageViewContainer() {
        self.imageViewContainer.layer.masksToBounds = true
        self.imageViewContainer.layer.cornerRadius = 20
    }
    
    func configureContentTableView() {
        self.contentTableView.register(UINib(nibName: "ProductsDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: ProductsDetailsTableViewCell.reuseId())
        self.contentTableView.dataSource = self
        self.contentTableView.rowHeight = UITableView.automaticDimension
        self.contentTableView.estimatedRowHeight = 70
    }
    
    
    func configureNavigationController() {
        self.title = "product_details_vc_title".localized()
    }
    
    // MARK: Other
    func resizeTableViewContainer() {
        self.contentContainerViewHeightConstraint.constant = self.contentTableView.contentSize.height
    }
    
    func show(activityIndicator: UIActivityIndicatorView!, show: Bool) {
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        activityIndicator.isHidden = !show
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .cancel, handler: { [weak self] (action) in
            self?.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadProductDetails() {
        self.show(activityIndicator: self.productActivityIndicator, show: true)
        self.manager.loadProduct(success: { [weak self] (imageUrl) in
            DispatchQueue.main.async {
                self?.show(activityIndicator: self?.imageActivityIndicator, show: true)
                self?.imageView.setImageFromUrl(ImageURL: imageUrl, completion: { (image) in
                    self?.imageViewContainerHeightConstraint.constant = image.size.height * (self?.imageViewContainerHeightConstraint.constant)! / image.size.width
                    self?.show(activityIndicator: self?.imageActivityIndicator, show: false)
                })
                self?.contentTableView.reloadData()
                self?.view.setNeedsLayout()
                self?.show(activityIndicator: self?.productActivityIndicator, show: false)
            }
        }) { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                self?.show(activityIndicator: self?.productActivityIndicator, show: false)
                self?.showErrorAlert(title: "error_title".localized(), message: errorMessage)
            }
        }
    }
}

extension ISProductDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.manager.amountOfProductContents()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductsDetailsTableViewCell.reuseId(), for: indexPath) as! ProductsDetailsTableViewCell
        let content = self.manager.content(for: indexPath)
        cell.set(value: content["value"]!, for: content["key"]!)
        return cell
    }
}
