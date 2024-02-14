//
//  PhotoGalleryCollectionViewCell.swift
//  imdb
//
//  Created by rauan on 1/10/24.
//
import Kingfisher
import UIKit

class PhotoGalleryCollectionViewCell: UICollectionViewCell {
    
    private let singlePhotoOfGalleryImageView: UIImageView = {
        let singlePhotoOfGalleryImageView = UIImageView()
        singlePhotoOfGalleryImageView.contentMode = .scaleAspectFit
        return singlePhotoOfGalleryImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        contentView.addSubview(singlePhotoOfGalleryImageView)
        singlePhotoOfGalleryImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
        }
    }
    
    func configure(actorsImagePath: String){
        let singlePhotoPath = "https://image.tmdb.org/t/p/w200\(actorsImagePath)"
        let url = URL(string: singlePhotoPath)!
        singlePhotoOfGalleryImageView.kf.setImage(with: url)
    }
}
