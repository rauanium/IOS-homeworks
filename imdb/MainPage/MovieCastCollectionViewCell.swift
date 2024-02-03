//
//  MovieCastCollectionViewCell.swift
//  imdb
//
//  Created by rauan on 12/24/23.
//

import UIKit
import Kingfisher
class MovieCastCollectionViewCell: UICollectionViewCell {
    
    var personImageView: UIImageView = {
        let personImage = UIImageView()
        personImage.frame.size.width = 100
        personImage.frame.size.height = 100
        personImage.layer.cornerRadius = personImage.frame.size.height / 2
        personImage.clipsToBounds = true
        personImage.contentMode = .scaleAspectFill
        personImage.layer.masksToBounds = true
        return personImage
    }()
    
    var personRealName: UILabel = {
        let personRealName = UILabel()
        personRealName.textAlignment = .left
        return personRealName
    }()
    
    var personInRole: UILabel = {
        let personInRole = UILabel()
        personInRole.textColor = .gray
        personInRole.textAlignment = .left
        personInRole.numberOfLines = 0
        return personInRole
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        [personImageView, personRealName, personInRole].forEach {
            contentView.addSubview($0)
        }
        contentView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(300)
        }
        
        personImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        personRealName.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-10)
            make.left.equalTo(personImageView.snp.right).offset(8)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(150)
            make.right.equalToSuperview()
        }
        personInRole.snp.makeConstraints { make in
            make.left.equalTo(personImageView.snp.right).offset(8)
            make.top.equalTo(personRealName.snp.bottom).offset(4)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(150)
            make.right.equalToSuperview()
        }
    }
    
    func configure(imagePath: String?, actorName: String, character: String) {
        
        personRealName.text = actorName
        personInRole.text = character
        let urlString = "https://image.tmdb.org/t/p/w200\(imagePath ?? "/wwemzKWzjKYJFfCeiB57q3r4Bcm.png")"
        let url = URL(string: urlString)!
        personImageView.kf.setImage(with: url)
//        DispatchQueue.global(qos: .userInitiated).async {
//            if let data = try? Data(contentsOf: url) {
//                DispatchQueue.main.async {
//                    self.personImageView.image = UIImage(data: data)
//                }
//            }
//        }        
    }
}
