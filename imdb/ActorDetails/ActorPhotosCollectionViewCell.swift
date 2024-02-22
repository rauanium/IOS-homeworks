//
//  ActorPhotosCollectionViewCell.swift
//  imdb
//
//  Created by rauan on 1/1/24.
//
import Kingfisher
import UIKit

class ActorPhotosCollectionViewCell: UICollectionViewCell {
    private var actorPhoto: UIImageView = {
        let actorPhoto = UIImageView()
        actorPhoto.layer.cornerRadius = 10
        actorPhoto.layer.masksToBounds = true
        actorPhoto.frame.size.width = 100
        actorPhoto.frame.size.height = 200
        actorPhoto.contentMode = .scaleAspectFill
        return actorPhoto
    }()
    private let imageBlurView: UIView = {
        let imageBlurView = UIView()
        imageBlurView.frame.size.width = 100
        imageBlurView.frame.size.height = 200
        imageBlurView.backgroundColor = .white
        imageBlurView.alpha = 0.8
        return imageBlurView
    }()
    
    private var actorsPhotosCountLabel: UILabel = {
        let actorsPhotosCountLabel = UILabel()
        actorsPhotosCountLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return actorsPhotosCountLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        contentView.addSubview(actorPhoto)
        
        actorPhoto.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.width.equalTo(200)
            make.edges.equalToSuperview()
        }
    }
    
    func configure(imagePath: String?, fourthImage: Int, totalNumberOfPhotos: Int){
        if fourthImage == 3 {
            blurImage(actorsPhotosNumber: totalNumberOfPhotos)
        }
        
        let actorPhotoPathURL = "https://image.tmdb.org/t/p/w200\(imagePath ?? "/wwemzKWzjKYJFfCeiB57q3r4Bcm.png")"
        let url = URL(string: actorPhotoPathURL)!
        actorPhoto.kf.setImage(with: url)
    }
    
    private func blurImage(actorsPhotosNumber: Int){
        actorPhoto.addSubview(imageBlurView)
        actorPhoto.addSubview(actorsPhotosCountLabel)
        actorsPhotosCountLabel.text = "+\(actorsPhotosNumber - 3)"
        
        actorsPhotosCountLabel.snp.makeConstraints { make in
            make.center.equalTo(actorPhoto)
        }
        
        imageBlurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
