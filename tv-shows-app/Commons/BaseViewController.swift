//
//  BaseViewController.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 18/11/2020.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dark_ligth
        setupNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .light
        navigationController?.navigationBar.backgroundColor = .dark
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.light, NSAttributedString.Key.font: UIFont.medium(17)]

        setNeedsStatusBarAppearanceUpdate()
    }
    
    func navigateToDetailView(tvShowId: Int64) {
        navigationController?.pushViewController(DetailViewController(tvShowId: tvShowId), animated: true)
    }
}
