//
//  SearchResultViewController.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class SearchResultViewController: BaseViewController {
    @UserDefault(key: UserDefaultKey.userProfile)
    private var userProfile: ProfileInfo!
    
    private let tableView = UITableView(frame: .zero)
    
    private let tempSearchResults: [SearchMovieSummary] = SearchMovieSummary.dummyMovies
    
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
        self.tableView.rowHeight = 150
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = CHColor.lightLabelBackground
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        self.tableView.backgroundColor = .clear
    }
    
    private func toggleLike(movieID: Int) {
        if self.userProfile.likedMovieIDs.contains(movieID) {
            self.userProfile.likedMovieIDs.removeAll { id in id == movieID }
        } else {
            self.userProfile.likedMovieIDs.append(movieID)
        }
        notifyLikedMovieMutated()
    }
    
    private func findMovieIfLiked(movieID: Int) -> Bool {
        return self.userProfile.likedMovieIDs.contains(movieID)
    }
    
    private func notifyLikedMovieMutated() {
        NotificationCenter.default.post(name: CHNotification.userLikedMovieMutated, object: nil)
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return self.tempSearchResults.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell: SearchMovieTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        else { return UITableViewCell() }
        let targetMovie = self.tempSearchResults[indexPath.row]
        let movieSummary = SearchMovieSummary(
            id: targetMovie.id,
            posterURL: targetMovie.posterURL,
            title: targetMovie.title,
            dateString: targetMovie.dateString,
            genres: targetMovie.genres,
            liked: findMovieIfLiked(movieID: targetMovie.id)
        )
        cell.configure(summary: targetMovie) { movieID in
            self.toggleLike(movieID: movieID)
        }
        return cell
    }
}
