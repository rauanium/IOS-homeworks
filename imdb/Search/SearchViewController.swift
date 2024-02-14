//
//  SearchViewController.swift
//  imdb
//
//  Created by rauan on 1/16/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search a movie"
        searchBar.searchBarStyle = .default
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        return searchBar
    }()
    
    private lazy var movieList: UITableView = {
        let movieList = UITableView()
        movieList.dataSource = self
        movieList.delegate = self
        movieList.showsVerticalScrollIndicator = false
        movieList.separatorStyle = .none
        movieList.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        return movieList
    }()
  
    private lazy var searchedResult: [SearchResult] = []{
        didSet{
            self.movieList.reloadData()
        }
    }
    
    private let themes = Themes.allCases
    private var networkManager = NetworkManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSearchQuery(searchText: "a")
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(movieList)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        movieList.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func loadSearchQuery(searchText: String) {
        networkManager.loadSearchQuery(with: searchText) { movie in
            self.searchedResult = movie
        }
    }
}

extension SearchViewController: UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieList.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        cell.configure(with: searchedResult[indexPath.row].title, and: searchedResult[indexPath.row].posterPath ?? "/cnqwv5Uz3UW5f086IWbQKr3ksJr.jpg")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let movieDetailViewController = MovieDetailsViewController()
            let movie = searchedResult[indexPath.row]
            movieDetailViewController.movieId = movie.id
            navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadSearchQuery(searchText: "a")
        } else {
            loadSearchQuery(searchText: searchText)
        }
        self.movieList.reloadData()
    }
}
