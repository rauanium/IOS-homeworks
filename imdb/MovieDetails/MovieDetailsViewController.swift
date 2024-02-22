//
//  MovieDetailsViewController.swift
//  imdb
//
//  Created by rauan on 12/19/23.
//
import SnapKit
import UIKit
import CoreData

class MovieDetailsViewController: BaseViewController {
    var movieId = Int()
    var exists: Bool = false
    var watchListMovies: [NSManagedObject] = []
    var watchListMoviesLoaded: MovieDetailsEntity?
    let dispatchGroup = DispatchGroup()
    let concurrentDispatch = DispatchQueue(label: "com.loadingFromApi", attributes: .concurrent)
    private lazy var starFromDB = "zeroStars"
    private var networkManager = NetworkManager.shared
    
    private lazy var movieGenres: [Genre] = []{
        didSet {
            self.genresCollectionView.reloadData()
        }
    }
    private lazy var cast:[Cast] = []{
        didSet {
            self.castCollectionView.reloadData()
        }
    }
    
    //MARK: - ui elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private let moviePosterFull: UIImageView = {
        let moviePosterFull = UIImageView()
        moviePosterFull.contentMode = .scaleAspectFill
        moviePosterFull.layer.cornerRadius = 10
        moviePosterFull.clipsToBounds = true
        return moviePosterFull
    }()
    
    private let movieTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private let stackViewOfReleaseAndStars: UIStackView = {
        let svOfReleaseAndStars = UIStackView()
        svOfReleaseAndStars.axis = .horizontal
        svOfReleaseAndStars.distribution = .fillEqually
        svOfReleaseAndStars.spacing = 8
        svOfReleaseAndStars.alignment = .top
        return svOfReleaseAndStars
    }()
    
    private let rightSideStackView: UIStackView = {
        let rightSideStackView = UIStackView()
        rightSideStackView.axis = .vertical
        rightSideStackView.distribution = .fillEqually
        rightSideStackView.spacing = 8
        rightSideStackView.alignment = .center
        return rightSideStackView
    }()
    
    private let leftSideStackView: UIStackView = {
        let leftSideStackView = UIStackView()
        leftSideStackView.axis = .vertical
        leftSideStackView.distribution = .fillEqually
        leftSideStackView.spacing = 8
        leftSideStackView.alignment = .center
        return leftSideStackView
    }()
    
    private let releaseDate: UILabel = {
        let releaseDate = UILabel()
        releaseDate.numberOfLines = 0
        releaseDate.text = "Release date: \n"
        return releaseDate
    }()
    
    private lazy var genresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let genresCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
        genresCollectionView.showsHorizontalScrollIndicator = false
        genresCollectionView.register(MovieStatusCollectionViewCell.self, forCellWithReuseIdentifier: "genresCollection")
        return genresCollectionView
    }()
    
    private let starsImageView: UIImageView = {
        let starsImageView = UIImageView()
        starsImageView.contentMode = .scaleAspectFit
        starsImageView.image = UIImage(named: "fiveStars")
        return starsImageView
    }()
    
    private let ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.textAlignment = .center
        ratingLabel.text = "9/10"
        return ratingLabel
        
    }()
    
    private let voteCountLabel: UILabel = {
        let voteCountLabel = UILabel()
        voteCountLabel.textAlignment = .center
        voteCountLabel.text = "0"
        return voteCountLabel
        
    }()
    
    private let descriptionView: UIView = {
        let descriptionView = UIView()
        descriptionView.backgroundColor = .gray
        return descriptionView
    }()
    
    private let overviewLabel: UILabel = {
        let overviewLabel = UILabel()
        overviewLabel.text = "Overview"
        overviewLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return overviewLabel
    }()
    
    private let movieDescriptionText: UILabel = {
        let movieDescriptionText = UILabel()
        movieDescriptionText.numberOfLines = 0
        movieDescriptionText.textAlignment = .left
        return movieDescriptionText
    }()
    
    private let castLabel: UILabel = {
        let castLabel = UILabel()
        castLabel.text = "Cast"
        castLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return castLabel
    }()
    
    private lazy var castCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection =  .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        castCollectionView.showsHorizontalScrollIndicator = false
        castCollectionView.register(MovieCastCollectionViewCell.self, forCellWithReuseIdentifier: "movieCastCell")
        return castCollectionView
    }()
    
    private let linkLabel: UILabel = {
        let linkLabel = UILabel()
        linkLabel.text = "Link"
        linkLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return linkLabel
    }()
    
    private let linksStackView: UIStackView = {
        let linksStackView = UIStackView()
        linksStackView.axis = .horizontal
        linksStackView.distribution = .fillEqually
        linksStackView.spacing = 16
        linksStackView.alignment = .center
        return linksStackView
    }()
    
    private let imdbImageView: UIImageView = {
        let imdbImageView = UIImageView()
        imdbImageView.contentMode = .scaleAspectFit
        imdbImageView.image = UIImage(named: "imdb")
        return imdbImageView
    }()
    
    private let youtubeImageView: UIImageView = {
        let youtubeImageView = UIImageView()
        youtubeImageView.contentMode = .scaleAspectFit
        youtubeImageView.image = UIImage(named: "youtube")
        return youtubeImageView
    }()
    
    private let facebookImageView: UIImageView = {
        let facebookImageView = UIImageView()
        facebookImageView.contentMode = .scaleAspectFit
        facebookImageView.image = UIImage(named: "facebook")
        return facebookImageView
    }()
    
    private lazy var addToFavourites: UIButton = {
        let addToFavourites = UIButton()
        addToFavourites.layer.cornerRadius = 4
        addToFavourites.addTarget(self, action: #selector(didAddToFavourites), for: .touchUpInside)
        return addToFavourites
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()   
        showLoader()
        loadData()
        loadCast()
        setupViews()
        setupNavigationController()
        
        loadWatchListMovies()

        exists = watchListMovies.contains { movie in
            movie.value(forKeyPath: "id") as? Int == movieId
        }
        
        if exists {
            addToFavourites.setTitle("Remove from Watchlist", for: .normal)
            addToFavourites.backgroundColor = .red
        }
        else {
            addToFavourites.setTitle("Add to Watchlist", for: .normal)
            addToFavourites.backgroundColor = .blue
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    @objc
    private func didAddToFavourites() {
        loadWatchListMovies()
        exists = watchListMovies.contains { movie in
            movie.value(forKeyPath: "id") as? Int == movieId
        }
        
        if exists {
            addToFavourites.setTitle("Add to Watchlist", for: .normal)
            addToFavourites.backgroundColor = .blue
            removeFromWatchList()
            print("ketirdim")
        }
        else {
            addToFavourites.setTitle("Remove from Watchlist", for: .normal)
            addToFavourites.backgroundColor = .red
            addToWatchList()
            print("qostym")
        }
    }
    
    private func loadWatchListMovies() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WatchList")
        do {
            watchListMovies = try managedContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print("Could not fetch. Error: \(error)")
        }
    }
    
    private func addToWatchList() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "WatchList", in: managedContext) else { return }
        let singleMovie = NSManagedObject(entity: entity, insertInto: managedContext)
        guard let movie = watchListMoviesLoaded else { return }
        singleMovie.setValue(movieId, forKey: "id")
        singleMovie.setValue(movie.originalTitle, forKey: "title")
        singleMovie.setValue(movie.posterPath, forKey: "posterPath")
        print("movie added")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. Error: \(error)")
        }
    }
    
    private func removeFromWatchList() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WatchList")
        
        guard let movie = watchListMoviesLoaded else { return }
        if let originalTitle = movie.originalTitle, let posterPath = movie.posterPath {
            let predicateID = NSPredicate(format: "id == %@", "\(movieId)")
            let predicateTitle = NSPredicate(format: "title == %@", originalTitle)
            let predicatePosterPath = NSPredicate(format: "posterPath == %@", posterPath)
            let predicateAll = NSCompoundPredicate(type: .and, subpredicates: [predicateID, predicateTitle, predicatePosterPath])
            fetchRequest.predicate = predicateAll
        }
        do {
            let results = try managedContext.fetch(fetchRequest)
            let data = results.first
            if let data {
                print("data: \(data)")
                managedContext.delete(data)
                
            }
            try managedContext.save()
            print("movie deleted")
            
        } catch let error as NSError {
            print("Could not delete. Error:  \(error)")
        }
    }
    
    @objc func didTapButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    //MARK: - Navigation controller
    private func setupNavigationController(){
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttribute
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.hidesBackButton = true
        let xmarkButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapButton))
        navigationItem.leftBarButtonItem = xmarkButton
    }
    
    //MARK: - setup constraints
    private func setupViews(){
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [moviePosterFull, movieTitle, stackViewOfReleaseAndStars,
         descriptionView, castLabel, castCollectionView, linkLabel, linksStackView, addToFavourites].forEach {
            contentView.addSubview($0)
        }
        [leftSideStackView, rightSideStackView].forEach {
            stackViewOfReleaseAndStars.addArrangedSubview($0)
        }
        [releaseDate, genresCollectionView].forEach{
            leftSideStackView.addArrangedSubview($0)
        }
        [starsImageView, ratingLabel, voteCountLabel].forEach{
            rightSideStackView.addArrangedSubview($0)
        }
        [overviewLabel, movieDescriptionText].forEach {
            descriptionView.addSubview($0)
        }
        [imdbImageView, youtubeImageView, facebookImageView].forEach {
            linksStackView.addArrangedSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        moviePosterFull.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.height.equalTo(400)
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
        }
        
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(moviePosterFull.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
        
        stackViewOfReleaseAndStars.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(movieTitle.snp.bottom).offset(8)
            make.height.equalTo(100)
            make.width.equalTo(view.frame.width)
            make.right.left.equalToSuperview().inset(16)
        }
        
        releaseDate.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(60)
        }
        
        genresCollectionView.snp.makeConstraints { make in
            make.top.equalTo(releaseDate.snp.bottom)
            make.left.right.equalToSuperview()
        }
        starsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.height.equalTo(50)
            make.width.equalTo(130)
        }
        ratingLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        voteCountLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom)
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(stackViewOfReleaseAndStars.snp.bottom).offset(16)
            make.bottom.equalTo(movieDescriptionText.snp.bottom).offset(16)
            make.width.equalToSuperview()
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        movieDescriptionText.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
        }
        
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        castCollectionView.snp.makeConstraints { make in
            make.top.equalTo(castLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(100)
            make.left.equalToSuperview().offset(16)
        }
        
        linkLabel.snp.makeConstraints { make in
            make.top.equalTo(castCollectionView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        linksStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(linkLabel.snp.bottom).offset(8)
            make.height.equalTo(100)
            make.width.equalTo(view.frame.width).offset(-16)
            make.right.left.equalToSuperview().inset(16)
            
        }
        
        imdbImageView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        youtubeImageView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        facebookImageView.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(70)
        }
        
        addToFavourites.snp.makeConstraints { make in
            make.top.equalTo(linksStackView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
        
        let youtubeGR = UITapGestureRecognizer(target: self, action: #selector(youtubeTapped))
        let imdbGR = UITapGestureRecognizer(target: self, action: #selector(youtubeTapped))
        let facebookGR = UITapGestureRecognizer(target: self, action: #selector(youtubeTapped))
        
        youtubeImageView.addGestureRecognizer(youtubeGR)
        imdbImageView.addGestureRecognizer(imdbGR)
        facebookImageView.addGestureRecognizer(facebookGR)
        imdbImageView.isUserInteractionEnabled = true
        youtubeImageView.isUserInteractionEnabled = true
        facebookImageView.isUserInteractionEnabled = true
        
        self.dispatchGroup.notify(queue: .main) {
//            usleep(3000_000)
            self.hideLoader()
        }
        }
    
    @objc
    func youtubeTapped(_ sender: UITapGestureRecognizer){
        if sender.view == imdbImageView {
            networkManager.loadExternalID(id: movieId) { externalID in
                let urlString = "https://www.imdb.com/title/" + externalID.imdbID
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
        }
        else if sender.view == youtubeImageView {
            networkManager.loadVideos(id: movieId) { videos in
                let youtubeVideos = videos.filter { video in
                    if let site = video.site {
                        site.contains("YouTube")
                    } else {
                        .init()
                    }
                }
                guard let key = youtubeVideos.first?.key else {
                    return
                }
                
                let urlString = "https://www.youtube.com/watch?v=" + key
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
                
            }
        }
        else if sender.view == facebookImageView {
            
            networkManager.loadExternalID(id: movieId) { externalID in
                let urlString = "https://www.facebook.com/" + externalID.facebookID
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
//MARK: - loading data of movie
extension MovieDetailsViewController {
    
    private func loadData() {
        
        dispatchGroup.enter()
        concurrentDispatch.async {
            self.networkManager.loadMovieDetails(id: self.movieId) { [weak self] movieDetails in
                guard let posterPath = movieDetails.posterPath else { return }
                
                let urlString = "https://image.tmdb.org/t/p/w200\(posterPath)"
                let url = URL(string: urlString)!
                DispatchQueue.global(qos: .userInitiated).async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self?.moviePosterFull.image = UIImage(data: data)
                        }
                    }
                }
                self?.dispatchGroup.leave()
                
                self?.watchListMoviesLoaded = movieDetails
                
                self?.navigationItem.title = movieDetails.originalTitle
                self?.movieTitle.text = movieDetails.originalTitle
                self?.movieDescriptionText.text = movieDetails.overview
                self?.releaseDate.text?.append(movieDetails.releaseDate!)
                self?.ratingLabel.text = "\(String(format: "%.1f", movieDetails.voteAverage ?? 0.0))/10"
                self?.voteCountLabel.text = "\(movieDetails.voteCount ?? 0)"
                self?.countStars(from: movieDetails.voteAverage)
                
                //MARK: - getting movie genres
                self?.movieGenres = movieDetails.genres
            }
        }
    }
    
//MARK: - load cast
    private func loadCast(){
        dispatchGroup.enter()
        concurrentDispatch.async {
            self.networkManager.loadMovieCast(id: self.movieId) { [weak self] movieCast in
                self?.cast = movieCast.cast
                print("movieCast: \(movieCast)")
            }
            self.dispatchGroup.leave()
        }
    }
}
    
//MARK: - Stars counting
extension MovieDetailsViewController {
    private func countStars(from: Double?){
        guard  let stars = from else {
            return
        }
        
        switch stars / 2.0 {
        case 0.0:
            starsImageView.image = UIImage(named: "zeroStars")
        case 0.1...0.9:
            starsImageView.image = UIImage(named: "zeroHalfStars")
        case 1.0...1.4:
            starsImageView.image = UIImage(named: "oneStars")
        case 1.5...1.9:
            starsImageView.image = UIImage(named: "oneHalfStars")
        case 2.0...2.4:
            starsImageView.image = UIImage(named: "twoStars")
        case 2.5...2.9:
            starsImageView.image = UIImage(named: "twoHalfStars")
        case 3.0...3.4:
            starsImageView.image = UIImage(named: "threeStars")
        case 3.5...3.9:
            starsImageView.image = UIImage(named: "threeHalfStars")
        case 4.0...4.4:
            starsImageView.image = UIImage(named: "fourStars")
        case 4.5...5.9:
            starsImageView.image = UIImage(named: "fourHalfStars")
        case 5.0:
            starsImageView.image = UIImage(named: "fiveStars")
        default:
            starsImageView.image = UIImage(named: "zeroStars")
        }
    }
}

//MARK: - Genres collection view
extension MovieDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castCollectionView {
            print("castCount: \(cast.count)")
            return cast.count
        }
        else {
            print("genresCount")
            return movieGenres.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == castCollectionView {
            let castCell = castCollectionView.dequeueReusableCell(withReuseIdentifier: "movieCastCell", for: indexPath) as! MovieCastCollectionViewCell
            let actor = cast[indexPath.row]
            castCell.configure(imagePath: actor.profilePath, actorName: actor.name, character: actor.character!)
            return castCell
            
        } else {
            let cell = genresCollectionView.dequeueReusableCell(withReuseIdentifier: "genresCollection", for: indexPath) as! MovieStatusCollectionViewCell
            cell.configure(with: movieGenres[indexPath.row].name)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == castCollectionView {
            return CGSize(width: 300, height: 40)
        }else {
            return CGSize(width: 150, height: 40)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let actorDetailViewController = ActorDetailsViewController()
        let actor = cast[indexPath.row]
        actorDetailViewController.actorId = actor.id
        print("---> Mark Walberg actorID: \(actor.id)")
        navigationController?.pushViewController(actorDetailViewController, animated: true)
    }
}


    
    
    


