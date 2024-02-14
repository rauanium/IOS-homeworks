//
//  LoadingView.swift
//  imdb
//
//  Created by rauan on 1/12/24.
//

import UIKit
import Lottie

class LoadingView: UIView {
    private enum Constats {
        static let animationViewSize: CGSize = .init(width: 150, height: 200)
    }
    
    var isLoading = false
    
    //MARK: - Properties
    private let containerView = UIView()
    
    private let newYearTreeAnimationView: LottieAnimationView = {
        let view = LottieAnimationView()
        let animation = LottieAnimation.named("newYearTreeAnimation")
        view.animation = animation
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1.25
        view.backgroundBehavior = .pauseAndRestore
        
        return view
    }()
    
    private let snowfallAnimationView: LottieAnimationView = {
        let view = LottieAnimationView()
        let animation = LottieAnimation.named("snowfallAnimation")
        view.animation = animation
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1.25
        view.backgroundBehavior = .pauseAndRestore
        return view
    }()
    
    
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Public methods
    func startLoading() {
        if isLoading { return }
        isLoading = true
        newYearTreeAnimationView.play(fromProgress: newYearTreeAnimationView.currentProgress, toProgress: 1, loopMode: .loop)
        snowfallAnimationView.play(fromProgress: snowfallAnimationView.currentProgress, toProgress: 1, loopMode: .loop)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func endLoading() {
        isLoading = false
        UIView.animate(withDuration: 0.65, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] _ in
            self?.newYearTreeAnimationView.stop()
            self?.snowfallAnimationView.stop()
        }
    }
    
    //MARK: - Private methods
    
    private func setupAnimation(){
        addSubview(containerView)
        containerView.addSubview(snowfallAnimationView)
        snowfallAnimationView.addSubview(newYearTreeAnimationView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        newYearTreeAnimationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constats.animationViewSize)
        }
        
        snowfallAnimationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
