//
//  ActorDetailsViewController.swift
//  imdb
//
//  Created by rauan on 1/1/24.
//

import UIKit

class ActorDetailsViewController: BaseViewController {
    //MARK: - variables
    var actorId = Int()
    let dispatchGroup = DispatchGroup()
    var networkManager = NetworkManager.shared
    lazy var actorImages: [Profile] = []{
        didSet {
            actorPhotosCollectionView.reloadData()
        }
    }
    
    lazy var actorsMoviesList: [ActorsMoviesInfo] = []{
        didSet {
            actorsMoviesCollectionView.reloadData()
        }
    }
    
    //MARK: - creating ui elements from top to bottom
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private let actorProfile: UIImageView = {
        let actorProfile = UIImageView()
        actorProfile.layer.cornerRadius = 10
        actorProfile.clipsToBounds = true
        actorProfile.contentMode = .scaleAspectFill
        return actorProfile
    }()
    
    private let actorName: UILabel = {
        let actorName = UILabel()
        actorName.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        actorName.numberOfLines = 0
        actorName.textAlignment = .center
        return actorName
    }()
    
    private let actorBirthDate: UILabel = {
        let actorBirthDate = UILabel()
        actorBirthDate.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        actorBirthDate.text = "Born: "
        actorBirthDate.numberOfLines = 0
        actorBirthDate.textAlignment = .center
        return actorBirthDate
    }()
    private let actorBirthPlace: UILabel = {
        let actorBirthPlace = UILabel()
        actorBirthPlace.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        actorBirthPlace.text = "Birthplace: "
        actorBirthPlace.numberOfLines = 0
        actorBirthPlace.textAlignment = .center
        return actorBirthPlace
    }()
    private let actorDeathDay: UILabel = {
        let actorDeathDay = UILabel()
        actorDeathDay.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        actorDeathDay.numberOfLines = 0
        actorDeathDay.textAlignment = .center
        return actorDeathDay
    }()
    private let bioView: UIView = {
        let bioView = UIView()
        bioView.backgroundColor = .gray
        return bioView
    }()
    private let bioLabel: UILabel = {
        let bioLabel = UILabel()
        bioLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        bioLabel.text = "Biography"
        bioLabel.textAlignment = .center
        return bioLabel
    }()
    private let actorBiography: UILabel = {
        let actorBiography = UILabel()
        actorBiography.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        actorBiography.numberOfLines = 0
        actorBiography.textAlignment = .left
        return actorBiography
    }()
    private let photoLabel: UILabel = {
        let photoLabel = UILabel()
        photoLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        photoLabel.text = "Photos"
        photoLabel.textAlignment = .center
        return photoLabel
    }()
    private lazy var actorPhotosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let actorPhotosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        actorPhotosCollectionView.delegate = self
        actorPhotosCollectionView.dataSource = self
        actorPhotosCollectionView.showsHorizontalScrollIndicator = false
        actorPhotosCollectionView.showsVerticalScrollIndicator = false
        actorPhotosCollectionView.register(ActorPhotosCollectionViewCell.self, forCellWithReuseIdentifier: "actorsPhotoCell")
        return actorPhotosCollectionView
    }()
    private let moviesLabel: UILabel = {
        let moviesLabel = UILabel()
        moviesLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        moviesLabel.text = "Movies"
        moviesLabel.textAlignment = .center
        return moviesLabel
    }()
    
    private lazy var actorsMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let actorsMoviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        actorsMoviesCollectionView.dataSource = self
        actorsMoviesCollectionView.dataSource = self
        actorsMoviesCollectionView.showsVerticalScrollIndicator = false
        actorsMoviesCollectionView.showsHorizontalScrollIndicator = false
        actorsMoviesCollectionView.register(ActrosMoviesCollectionViewCell.self, forCellWithReuseIdentifier: "actorsMoviesCell")
        return actorsMoviesCollectionView
    }()
    private let linkLabel: UILabel = {
        let linkLabel = UILabel()
        linkLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        linkLabel.text = "Link"
        linkLabel.textAlignment = .center
        return linkLabel
    }()
    
    private let linkStackView: UIStackView = {
        let linkStackView = UIStackView()
        linkStackView.axis = .horizontal
        linkStackView.spacing = 100
        linkStackView.distribution = .fillEqually
        
        linkStackView.alignment = .center
        return linkStackView
    }()
    
    private let imdbImage: UIImageView = {
        let imdbImage = UIImageView()
        imdbImage.contentMode = .scaleAspectFit
        imdbImage.image = UIImage(named: "imdb")
        return imdbImage
    }()
    private let instagramImage: UIImageView = {
        let instagramImage = UIImageView()
        instagramImage.contentMode = .scaleAspectFit
        instagramImage.image = UIImage(named: "instagram")
        return instagramImage
    }()
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        showLoader()
        loadActorDetails()
        loadActorImages()
        loadActorsMovies()
        creatingGestures()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttribute
        navigationController?.navigationBar.tintColor = .black
        navigationItem.hidesBackButton = true
        let xmarkButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapButton))
        navigationItem.leftBarButtonItem = xmarkButton
    }
    
    //MARK: - functions
    @objc func didTapButton(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - UI setting up / constraints
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [actorProfile, actorName, actorBirthDate, actorBirthPlace, actorDeathDay, bioView, photoLabel, actorPhotosCollectionView, moviesLabel, actorsMoviesCollectionView, linkLabel, linkStackView].forEach {
            contentView.addSubview($0)
        }
        bioView.addSubview(bioLabel)
        bioView.addSubview(actorBiography)
        
        linkStackView.addArrangedSubview(imdbImage)
        linkStackView.addArrangedSubview(instagramImage)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.bottom.right.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.centerX.equalTo(scrollView.snp.centerX)
            make.width.equalTo(view.frame.width)
        }
        actorProfile.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(350)
            make.height.equalTo(480)
        }
        actorName.snp.makeConstraints { make in
            make.top.equalTo(actorProfile.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        actorBirthDate.snp.makeConstraints { make in
            make.top.equalTo(actorName.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        actorBirthPlace.snp.makeConstraints { make in
            make.top.equalTo(actorBirthDate.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        actorDeathDay.snp.makeConstraints { make in
            make.top.equalTo(actorBirthPlace.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        bioView.snp.makeConstraints { make in
            make.top.equalTo(actorDeathDay.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(actorBiography.snp.bottom).offset(16)
        }
        bioLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        actorBiography.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
        }
        photoLabel.snp.makeConstraints { make in
            make.top.equalTo(bioView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            
        }
        actorPhotosCollectionView.snp.makeConstraints { make in
            make.top.equalTo(photoLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.equalToSuperview()
            make.height.equalTo(150)
            
        }
        moviesLabel.snp.makeConstraints { make in
            make.top.equalTo(actorPhotosCollectionView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        actorsMoviesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(moviesLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.equalToSuperview()
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
        linkLabel.snp.makeConstraints { make in
            make.top.equalTo(actorsMoviesCollectionView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        linkStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(linkLabel.snp.bottom).offset(8)
            make.width.equalTo(view.frame.width).offset(-16)
            make.right.left.equalToSuperview().inset(16)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        imdbImage.snp.makeConstraints { make in
            ///works without constraints
            make.height.equalTo(50)
            
        }
        instagramImage.snp.makeConstraints { make in
            ///works without constraints
            make.height.equalTo(50)
        }
        dispatchGroup.notify(queue: .main){
            self.hideLoader()
        }
        
    }
}
//MARK: - load data
extension ActorDetailsViewController {
    //MARK: - loading actor data details
    
    func loadActorDetails(){
        
        dispatchGroup.enter()
        networkManager.loadActorDetails(id: actorId) { actorDetails in
            guard let posterPath = actorDetails.profilePath else { return }
            self.navigationItem.title = actorDetails.name
            let urlString = "https://image.tmdb.org/t/p/w200\(posterPath)"
            let url = URL(string: urlString)!
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.actorProfile.image = UIImage(data: data)
                        self.dispatchGroup.leave()
                    }
                }
            }
            self.actorName.text = actorDetails.name
            self.actorBirthDate.text?.append(actorDetails.birthday)
            self.actorBirthPlace.text?.append(actorDetails.placeOfBirth)
            if let deathDay = actorDetails.deathday {
                self.actorDeathDay.text?.append("Deathdate: \(deathDay)")
            }
            self.actorBiography.text = actorDetails.biography
        }
    }
    //MARK: - load actor images
    
    func loadActorImages(){
        dispatchGroup.enter()
        networkManager.loadActorImages(id: actorId) {[weak self] actorImages in
            self?.actorImages = actorImages.profiles
            self?.dispatchGroup.leave()
        }
    }
    
    //MARK: - load actors movies
    func loadActorsMovies(){
        dispatchGroup.enter()
        networkManager.loadActorsMovies(id: actorId) { actorsMovies in
            self.actorsMoviesList = actorsMovies.cast
            print(self.actorsMoviesList[0].originalTitle)
            self.dispatchGroup.leave()
        }
    }
}

//MARK: - creating gestures of social media
extension ActorDetailsViewController {
    
    func creatingGestures(){
        print("called creatingGestures function")
        let imdbGR = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        let instagramGR = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imdbImage.addGestureRecognizer(imdbGR)
        imdbImage.isUserInteractionEnabled = true
        instagramImage.addGestureRecognizer(instagramGR)
        instagramImage.isUserInteractionEnabled = true
    }
    @objc func imageTapped(_ sender: UITapGestureRecognizer){
        networkManager.loadActorsSocialMedia(id: actorId) { actorsSocialMedia in
            if sender.view == self.imdbImage {
                print("tapped imdb")
                let urlString = "https://www.imdb.com/name/" + actorsSocialMedia.imdbID
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
            else if sender.view == self.instagramImage {
                print("tapped instagram")
                let urlString = "https://www.instagram.com/" + actorsSocialMedia.instagramID
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
        }
        
    }
}


//MARK: - collection view delegate and datasource
extension ActorDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == actorsMoviesCollectionView {
            return actorsMoviesList.count
        } else {
            print("actrosmoviesList: \(actorsMoviesList.count)")
            if actorImages.count >= 4 {
                return 4
            } else {
                return actorImages.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == actorsMoviesCollectionView {
            let cell = actorsMoviesCollectionView.dequeueReusableCell(withReuseIdentifier: "actorsMoviesCell", for: indexPath) as! ActrosMoviesCollectionViewCell
            let actorsMovieEntity = actorsMoviesList[indexPath.row]
            cell.configure(posterPath: actorsMovieEntity.posterPath ?? "/wwemzKWzjKYJFfCeiB57q3r4Bcm.png", originalTitle: actorsMovieEntity.originalTitle, releaseYear: actorsMovieEntity.releaseDate!)
            return cell
        } else {
            let cell = actorPhotosCollectionView.dequeueReusableCell(withReuseIdentifier: "actorsPhotoCell", for: indexPath) as! ActorPhotosCollectionViewCell
            cell.configure(imagePath: actorImages[indexPath.row].filePath, fourthImage: indexPath.row, totalNumberOfPhotos: actorImages.count)            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == actorsMoviesCollectionView{
            return CGSize(width: 330, height: 50)
        } else{
            return CGSize(width: 90, height: 150)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoGalleryViewController = PhotoGalleryViewController()
        photoGalleryViewController.actorPhotos = actorImages
        photoGalleryViewController.photoID = indexPath
        
        navigationController?.pushViewController(photoGalleryViewController, animated: true)
        
        
                
        
        
    }
    
    
}
