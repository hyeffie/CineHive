//
//  SearchResultViewController.swift
//  CineHive
//
//  Created by Effie on 1/31/25.
//

import UIKit

final class SearchResultViewController: BaseViewController {
    private enum ContentState: ContenUnavailableState {
        case noResult
        
        var displayingMessage: String {
            switch self {
            case .noResult: return "원하는 검색 결과를 찾지 못했습니다"
            }
        }
    }
    
    private let viewModel: SearchResultViewModel
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView = UITableView(frame: .zero)
    
    init(
        viewModel: SearchResultViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        self.viewModel.input.initialized.value = ()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.input.viewDidAppear.value = ()
    }
    
    private func bind() {
        self.viewModel.output.resultSummaries.lazyBind { [weak self]  results in
            self?.tableView.reloadData()
            self?.contentIsAvailable = results.isEmpty ? .unavailable(ContentState.noResult) : .available
        }
        
        self.viewModel.output.goToDetail.lazyBind { [weak self] detail in
            guard let detail else { return }
            self?.goToDetail(detail)
        }
        
        self.viewModel.output.errorMessage.lazyBind { [weak self] message in
            guard let message else { return }
            self?.presentErrorAlert(message: message)
        }
        
        self.viewModel.output.showKeyboard.lazyBind { [weak self] in
            DispatchQueue.main.async {
                self?.searchController.searchBar.becomeFirstResponder()
            }
        }
    }
}

extension SearchResultViewController {
    private func configureViews() {
        self.navigationItem.title = "영화 검색"
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        configureSearchController()
        configureTableView()
    }
    
    private func configureSearchController() {
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "영화를 검색해보세요."
        self.searchController.searchBar.searchTextField.clearButtonMode = .never
        self.searchController.automaticallyShowsCancelButton = false
//        self.searchController.searchBar.text = self.latestQuery
        navigationItem.searchController = self.searchController
    }
    
    private func configureTableView() {
        self.tableView.registerCellClass(SearchMovieTableViewCell.self)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.prefetchDataSource = self
        self.tableView.rowHeight = 150
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = CHColor.lightLabelBackground
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        self.tableView.backgroundColor = .clear
    }
    
    private func goToDetail(_ detail: MovieDetail) {
        let viewController = MovieDetailViewController(movieDetail: detail)
        self.push(viewController)
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return self.viewModel.output.resultSummaries.value.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell: SearchMovieTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        else { return UITableViewCell() }
        let searchSummary = self.viewModel.output.resultSummaries.value[indexPath.row]
        cell.configure(summary: searchSummary) { [weak self] movieID in
            self?.viewModel.input.likeButtonTappedForMovieID.value = movieID
        }
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.input.didSelectCellAtIndex.value = indexPath.row
    }
}

extension SearchResultViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.viewModel.input.searchButtonClickedWithQuery.value = query
    }
}

extension SearchResultViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        self.viewModel.input.prefetchItemsAt.value = indexPaths.map(\.row)
    }
}
