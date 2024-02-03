//
//  MovieStatusCollectionViewCell.swift
//  imdb
//
//  Created by rauan on 12/12/23.
//

import UIKit

class MovieStatusCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = self.isSelected ? .red : .cellBackgroundNotSelected
            movieStatusLabel.textColor = self.isSelected ? .white : .black
        }
    }
    
    let movieStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(movieStatusLabel)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        backgroundColor = .cellBackgroundNotSelected
        layer.cornerRadius = 14
        clipsToBounds = true
        
        movieStatusLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    func configure(with title: String){
        self.movieStatusLabel.text = title
    }
}
