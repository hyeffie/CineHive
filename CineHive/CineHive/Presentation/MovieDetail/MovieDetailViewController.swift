//
//  MovieDetailViewController.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    
    private let movieDetail: MovieDetail
    
    private let scrollView = UIScrollView()
    
    private let contentStack = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12
        return stack
    }()
    
    init(movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
            make.width.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.scrollView.addSubview(self.contentStack)
        self.contentStack.snp.makeConstraints { make in
            make.edges.width.equalTo(self.scrollView)
        }
        
        [UIColor.red, .green, .blue].forEach { color in
            let view = UIView()
            view.backgroundColor = color
            self.contentStack.addArrangedSubview(view)
            
            view.snp.makeConstraints { make in
                make.height.equalTo(300)
            }
        }
    }
}
