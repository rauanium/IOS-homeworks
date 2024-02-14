//
//  TabBarViewController.swift
//  imdb
//
//  Created by rauan on 1/16/24.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    //MARK: - private properties
    private let tabBarTitles: [String] = ["Home", "For you", "Favorites", "Search", "Profile"]
    private let tabBarIcons: [UIImage?] = [UIImage(named: "icon_home"), UIImage(named: "icon_for_you"), UIImage(named: "icon_favorites"), UIImage(named: "icon_search"), UIImage(named: "icon_profile")]
    
    //MARK: - VeiwController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarViews()
        
    }
    private var allViewControllers = [
        UINavigationController(rootViewController: MainViewController()),
        ForYouViewController(),
        UINavigationController(rootViewController: FavoriteViewController()),
        SearchViewController(),
        UINavigationController(rootViewController: ProfileViewController())
    ]
    
    //MARK: - Private methods
    private func setupTabBarViews() {
        view.backgroundColor = .systemGray
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        setViewControllers(allViewControllers, animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        for i in 0..<items.count {
            items[i].title = tabBarTitles[i]
            items[i].image = tabBarIcons[i]
        }
        
    }
     
}
