//
//  BaseViewController.swift
//  imdb
//
//  Created by rauan on 1/12/24.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {

    //MARK: - Properties
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.layer.zPosition = 10
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.alpha = 0
        view.frame = view.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        // Do any additional setup after loading the view.
    }
    //MARK: - Public methods
    func showLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.startLoading()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.endLoading()
        }
    }
    
    //MARK: - private methods
    private func setupLoadingView(){
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
    }

}
