//
//  SearchResultViewController.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class SearchResultViewController: UIViewController {
    private let tableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        configureTableView()
    }
    
    private func configureTableView() {
        self.tableView.registerCellClass(SearchMovieTableViewCell.self)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 10
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell: SearchMovieTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        else { return UITableViewCell() }
        
        return cell
    }
}
