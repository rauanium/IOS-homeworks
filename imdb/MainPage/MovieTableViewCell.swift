//
//  MovieTableViewCell.swift
//  imdb
//
//  Created by rauan on 12/2/23.
//

import UIKit
import Kingfisher
import Lottie

class MovieTableViewCell: UITableViewCell {
    var didTapFavorite: (() -> Void)?
    var moviePoster: UIImageView = {
        let moviePoster = UIImageView()
        moviePoster.layer.cornerRadius = 10
        moviePoster.layer.masksToBounds = true
        moviePoster.isUserInteractionEnabled = true
        return moviePoster
    }()
    
    var movieTitle: UILabel = {
        let movieTitle = UILabel()
        movieTitle.numberOfLines = 0
        movieTitle.textAlignment = .center
        movieTitle.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return movieTitle
    }()
    
    //MARK: - adding like button animation
    private lazy var likeAnimationView: LottieAnimationView = {
        let likeAnimationView = LottieAnimationView(name: "likeAnimation")
        likeAnimationView.contentMode = .scaleAspectFit
        likeAnimationView.animationSpeed = 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFavoriteIcon))
        likeAnimationView.addGestureRecognizer(tapGesture)
        likeAnimationView.isUserInteractionEnabled = true
        return likeAnimationView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "movieCell")
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleFavoriteIcon(with isFavorite: Bool) {
        if isFavorite {
            likeAnimationView.play(fromProgress: 0.0, toProgress: 0.5, loopMode: .playOnce, completion: nil)
        } else {
            likeAnimationView.play(fromProgress: 0.5, toProgress: 1.0, loopMode: .playOnce, completion: nil)
        }
    }
    
    @objc private func didTapFavoriteIcon(){
        print("didTapFavorite")
        didTapFavorite?()
    }
    
    func setupViews(){
        self.contentView.addSubview(moviePoster)
        self.contentView.addSubview(movieTitle)
        moviePoster.addSubview(likeAnimationView)
        selectionStyle = .none
        backgroundColor = .clear
        
        moviePoster.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(16)
            make.height.equalTo(560)
        }
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(moviePoster.snp.bottom)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
            make.centerX.equalTo(moviePoster.snp.centerX)
            make.height.greaterThanOrEqualTo(60)
            make.width.equalTo(contentView.snp.width)
        }
        likeAnimationView.snp.makeConstraints { make in
            make.top.equalTo(moviePoster.snp.top)
            make.right.equalTo(moviePoster.snp.right)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }        
    }
    
    func configure(with title: String, and imagePath: String){
        movieTitle.text = title
        let urlString = "https://image.tmdb.org/t/p/w200\(imagePath)"
        let url = URL(string: urlString)!
        moviePoster.kf.setImage(with: url)
      }
}



