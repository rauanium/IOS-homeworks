//
//  EmptyStateView.swift
//  imdb
//
//  Created by rauan on 2/15/24.
//

import UIKit

class EmptyStateView: UIView {
    
    //MARK: - properties
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var stateImage: UIImageView = {
        let stateImage = UIImageView()
        stateImage.contentMode = .scaleAspectFill
        return stateImage
    }()
    
    private lazy var stateTitle: UILabel = {
        let stateTitle = UILabel()
        stateTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        stateTitle.textAlignment = .center
        return stateTitle
    }()
    
    private lazy var stateSubtitle: UILabel = {
        let stateSubtitle = UILabel()
        stateSubtitle.textAlignment = .center
        stateSubtitle.font = UIFont.systemFont(ofSize: 16)
        return stateSubtitle
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Closed methods
    private func setupView() {
        addSubview(stackView)
        backgroundColor = .clear
        
        [stateImage, stateTitle, stateSubtitle].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        stateImage.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(135)
            make.width.lessThanOrEqualTo(200)
        }
        stateTitle.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(24)
        }
    }
    
    func configure(image: UIImage, title: String, subtitle: String) {
        stateImage.image = image
        stateTitle.text = title
        stateSubtitle.text = subtitle
    }
    
    
    
}
