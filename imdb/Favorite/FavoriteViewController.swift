//
//  FavoriteViewController.swift
//  imdb
//
//  Created by rauan on 1/16/24.
//

import SnapKit
import UIKit
import CoreData

class FavoriteViewController: UIViewController {
    //MARK: - Properties
    private lazy var favoriteMovies: [NSManagedObject] = []{
        didSet {
            self.movieTableView.reloadData()
        }
    }
    
    private lazy var movieTableView: UITableView = {
        let movieTableView = UITableView()
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.backgroundColor = .clear
        movieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieCell")
        movieTableView.separatorStyle = .none
        movieTableView.showsVerticalScrollIndicator = false
        return movieTableView
    }()
    
    private lazy var emptyStateView: EmptyStateView = {
        let emptyStateView = EmptyStateView()
        emptyStateView.isHidden = false
        emptyStateView.configure(image: UIImage(named: "emptyStateFavourite")!, title: "You do not have favourite movies ", subtitle: "Try adding some")
        return emptyStateView
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMovies()
    }
    //MARK: - Methods
    
    private func handleEmptyStateView(show: Bool) {
        emptyStateView.isHidden = !show
    }
    
    private func loadMovies() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        
        do {
            favoriteMovies = try managedContext.fetch(fetchRequest)
            if favoriteMovies == [] {
                handleEmptyStateView(show: true)
            } else {
                handleEmptyStateView(show: false)
            }
            
        } catch let error as NSError {
            
            print("Could not fetch. Error: \(error)")
        }
    }
    
    private func removeFavoriteMovie(with movie: Result){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteMovies")
        let predicateId = NSPredicate(format: "id == %@", "\(movie.id)")
        let predicateTitle = NSPredicate(format: "title == %@", movie.title)
        let predicatePosterPath = NSPredicate(format: "posterPath == %@", movie.posterPath)
        let predicateAll = NSCompoundPredicate(type: .and, subpredicates: [predicateId, predicateTitle, predicatePosterPath])
        fetchRequest.predicate = predicateAll
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            print(results)
            let data = results.first
            if let data {
                managedContext.delete(data)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete. Error: \(error)")
        }
    }
    
}
    
    //MARK: - Constraints
    extension FavoriteViewController {
        private func setupViews(){
            navigationItem.title = "Favourites"
            view.backgroundColor = .white
            
            [movieTableView, emptyStateView].forEach {
                view.addSubview($0)
            }
            
            movieTableView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.right.left.bottom.equalTo(view.safeAreaLayoutGuide)
            }
            emptyStateView.snp.makeConstraints { make in
                make.edges.equalTo(movieTableView)
            }
        }
    }
    
    //MARK: - TableViewDelegate section
    extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favoriteMovies.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
            let movie = favoriteMovies[indexPath.row]
            let title = movie.value(forKeyPath: "title") as? String
            let posterPath = movie.value(forKeyPath: "posterPath") as? String
            cell.configure(with: title ?? "", and: posterPath ?? "")
            
            let isFavoriteMovie = !self.favoriteMovies.filter({
                ($0.value(forKeyPath: "id") as? Int) == movie.value(forKeyPath: "id") as? Int }).isEmpty
            cell.toggleFavoriteIcon(with: isFavoriteMovie)
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let movieDetailViewController = MovieDetailsViewController()
            let movie = favoriteMovies[indexPath.row]
            let id = movie.value(forKeyPath: "id") as? Int
            movieDetailViewController.movieId = id ?? 0
            navigationController?.pushViewController(movieDetailViewController, animated: true)
        }
    }

