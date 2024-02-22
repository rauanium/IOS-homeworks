//
//  ActrosMoviesCollectionViewCell.swift
//  imdb
//
//  Created by rauan on 1/1/24.
//
import Kingfisher
import UIKit

class ActrosMoviesCollectionViewCell: UICollectionViewCell {
    
    private var moviesPoster: UIImageView = {
        let moviesPoster = UIImageView()
        moviesPoster.contentMode = .scaleAspectFill
        moviesPoster.clipsToBounds = true
        moviesPoster.layer.cornerRadius = 10
        return moviesPoster
    }()
    
    private var movieTitle: UILabel = {
        let movieTitle = UILabel()
        movieTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        movieTitle.numberOfLines = 0
        movieTitle.textAlignment = .left
        return movieTitle
    }()
    
    private var movieReleaseYear: UILabel = {
        let movieReleaseYear = UILabel()
        movieReleaseYear.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        movieReleaseYear.textColor = .gray
        movieReleaseYear.textAlignment = .center
        movieReleaseYear.numberOfLines = 0
        return movieReleaseYear
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        [moviesPoster, movieTitle, movieReleaseYear].forEach {
            contentView.addSubview($0)
        }
        contentView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(200)
        }
        moviesPoster.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(70)
        }
        movieTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.left.equalTo(moviesPoster.snp.right).offset(8)
            make.height.greaterThanOrEqualTo(30)
            make.width.lessThanOrEqualTo(150)
            make.right.equalToSuperview()
        }
        movieReleaseYear.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom)
            make.left.equalTo(movieTitle.snp.left)
        }
    }
    
    func configure(posterPath: String, originalTitle: String, releaseYear: String){
        let urlString = "https://image.tmdb.org/t/p/w200\(posterPath)"
        let url = URL(string: urlString)!
        moviesPoster.kf.setImage(with: url)
        movieTitle.text = originalTitle
        movieReleaseYear.text = releaseYear
    }
}
