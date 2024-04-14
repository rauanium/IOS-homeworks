//
//  PhotoGalleryViewController.swift
//  imdb
//
//  Created by rauan on 1/10/24.
//

import UIKit

class PhotoGalleryViewController: UIViewController {
    
    var photoID = IndexPath()
    var actorID = Int()
    var actorPhotos: [Profile] = []
    
    private lazy var photoGalleryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let photoGalleryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoGalleryCollectionView.backgroundColor = .clear
        photoGalleryCollectionView.showsHorizontalScrollIndicator = false
        photoGalleryCollectionView.dataSource = self
        photoGalleryCollectionView.delegate = self
        photoGalleryCollectionView.isPagingEnabled = true
        photoGalleryCollectionView.register(PhotoGalleryCollectionViewCell.self, forCellWithReuseIdentifier: "photoGalleryCell")
        return photoGalleryCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationController()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.photoGalleryCollectionView.scrollToItem(at: photoID, at: .top, animated: false)
    }
    
    private func setupNavigationController(){
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttribute
        navigationController?.navigationBar.tintColor = .white
        navigationItem.hidesBackButton = true
        let xmarkButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(exitButtonTapped))
        navigationItem.rightBarButtonItem = xmarkButton
    }
    
    @objc private func exitButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    private func setupViews(){
        view.backgroundColor = .black
        self.title = "\(photoID.row + 1)/\(actorPhotos.count)"
        view.addSubview(photoGalleryCollectionView)
        
        photoGalleryCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//MARK: - collection view delegate, datasource
extension PhotoGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actorPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoGalleryCollectionView.dequeueReusableCell(withReuseIdentifier: "photoGalleryCell", for: indexPath) as! PhotoGalleryCollectionViewCell
        cell.configure(actorsImagePath: actorPhotos[indexPath.row].filePath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            let visibleIndexPath = collectionView.indexPathsForVisibleItems
            if let lastIndexPath = visibleIndexPath.last {
                self.title = "\(lastIndexPath.row + 1)/\(actorPhotos.count)"
            }
        }
    }
}
