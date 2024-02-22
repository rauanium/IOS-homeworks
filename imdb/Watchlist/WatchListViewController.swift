//
//  ForYouViewController.swift
//  imdb
//
//  Created by rauan on 1/16/24.
//

import UIKit
import CoreData

class WatchListViewController: UIViewController {
    var watchlistMovies: [NSManagedObject] = []{
        didSet {
            moviesTableView.reloadData()
        }
    }
    
    private lazy var moviesTableView: UITableView = {
        let moviesTableView = UITableView()
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "watchListCell")
        moviesTableView.backgroundColor = .clear
        moviesTableView.separatorStyle = .none
        moviesTableView.showsVerticalScrollIndicator = false
        return moviesTableView
    }()
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView()
        emptyStateView.configure(image: UIImage(named: "emptyStateWatchlist")!, title: "No movies in Watchlist", subtitle: "Try adding some")
        emptyStateView.isHidden = true
        return emptyStateView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMovies()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(moviesTableView)
        navigationItem.title = "Watchlist"
        moviesTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        emptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(moviesTableView)
        }
    }
}

//MARK: - Core data section
extension WatchListViewController {
    private func loadMovies() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WatchList")
        do {
            watchlistMovies =  try managedContext.fetch(fetchRequest)
            if watchlistMovies == [] {
                handleEmptyStateView(show: true)
            } else {
                handleEmptyStateView(show: false)
            }
        }
        catch let error as NSError {
            print("Could not fetch. Error: \(error)")
        }
    }
    
    private func handleEmptyStateView(show: Bool) {
        emptyStateView.isHidden = !show
    }
    
    
}
//MARK: - TableView Delegate and DataSource
extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlistMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "watchListCell", for: indexPath) as! MovieTableViewCell
        let singleMovie = watchlistMovies[indexPath.row]
        let title = singleMovie.value(forKeyPath: "title") as? String
        let posterPath = singleMovie.value(forKeyPath: "posterPath") as? String
        cell.configure(with: title ?? "", and: posterPath ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let watchListMovieDetailsViewController = WatchListMovieDetailsViewController()
        let movieID = watchlistMovies[indexPath.row].value(forKeyPath: "id") as? Int
        guard let movieID else { return }
        watchListMovieDetailsViewController.movieId = movieID
        navigationController?.pushViewController(watchListMovieDetailsViewController, animated: true)
        
    }
}

