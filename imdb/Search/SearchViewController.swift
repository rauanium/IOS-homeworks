//
//  SearchViewController.swift
//  imdb
//
//  Created by rauan on 1/16/24.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    private var getRecommendedID = UserDefaults.standard.integer(forKey: "recommendedID")
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
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView()
        emptyStateView.configure(image: UIImage(named: "emptyStateSearch")!, title: "Could not find", subtitle: "Try something different")
        emptyStateView.isHidden = true
        return emptyStateView
    }()
    private lazy var searchedResult: [SearchResult] = []{
        didSet{
            self.movieList.reloadData()
        }
    }
    private var favoriteMovies: [NSManagedObject] = []
    private var watchlistMovies: [NSManagedObject] = []
    private let themes = Themes.allCases
    private var networkManager = NetworkManager.shared
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        print("recID: \(getRecommendedID)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteMovies()
        loadWatchlistMovies()
        loadRecomendedMovies()
    }
    
    //MARK: - Constraints
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Search"
        [searchBar, movieList, emptyStateView].forEach {
            view.addSubview($0)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        movieList.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        emptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(movieList)
        }
    }
    
    private func loadSearchQuery(searchText: String) {
        networkManager.loadSearchQuery(with: searchText) { result in
            switch result {
            case .success(let movies):
                self.searchedResult = movies
                print("rec: \(movies)")
                if self.searchedResult.isEmpty  {
                    self.handleEmptyStateView(show: true)
                } else {
                    self.handleEmptyStateView(show: false)
                }
                
            case .failure:
                self.handleEmptyStateView(show: true)
            }
        }
    }
    
    private func loadRecomendedMovies() {
        networkManager.loadRecomendedMovies(with: recomendMovieID()) { recomendedMovies in
            self.searchedResult = recomendedMovies
            if self.searchedResult.isEmpty  {
                self.handleEmptyStateView(show: true)
            } else {
                self.handleEmptyStateView(show: false)
            }
        }
    }
    private func handleEmptyStateView(show: Bool) {
        emptyStateView.isHidden = !show
    }
    
    private func recomendMovieID() -> Int {
        if let favouriteMovieID = favoriteMovies.first?.value(forKeyPath: "id") as? Int {
            print("fav \(favouriteMovieID)")
            return favouriteMovieID
        }
        else if let watchListMovieID = watchlistMovies.first?.value(forKeyPath: "id") as? Int {
            print("watch \(watchListMovieID)")
            return watchListMovieID
        }
        else {
            return 787699
        }
    }
    private func loadFavoriteMovies() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")

        do {
            favoriteMovies = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. Error: \(error)")
        }
    }
    
    private func loadWatchlistMovies() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WatchList")
        
        do {
            watchlistMovies = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. Error: \(error)")
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
            loadRecomendedMovies()
        } else {
            loadSearchQuery(searchText: searchText)
        }
        self.movieList.reloadData()
    }
}
