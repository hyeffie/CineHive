//
//  ProfileImageViewController.swift
//  CineHive
//
//  Created by Effie on 1/28/25.
//

import UIKit

final class ProfileImageViewController: BaseViewController {
    private let viewModel: ProfileImageViewModel

    private let selectedProfileImageView = SelectedProfileImageView()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.collectionViewLayout()
    )
    
    init(
        viewModel: ProfileImageViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.viewModel.viewDidLoad.value = ()
    }
    
    private func bind() {
        self.viewModel.navigationTitle.lazyBind { [weak self] title in
            self?.navigationItem.title = title
        }
        
        self.viewModel.selectedCellIndex.lazyBind { [weak self] cellIndex in
            guard let cellIndex else { return }
            let selectedIndexPath = IndexPath(item: cellIndex, section: 0)
            self?.collectionView.selectItem(
                at: selectedIndexPath,
                animated: false,
                scrollPosition: .top
            )
        }
        
        self.viewModel.selectedImageNumber.lazyBind { [weak self] imageNumber in
            self?.selectedProfileImageView.configureImage(number: imageNumber)
        }
    }
}

extension ProfileImageViewController {
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let hInset: CGFloat = 16
        let numberOfItemsInLine: CGFloat = 4
        let spacing: CGFloat = 12
        let itemWidth = (self.view.frame.width - 2 * hInset - (numberOfItemsInLine - 1) * spacing) / numberOfItemsInLine
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = .init(width: itemWidth, height: itemWidth)
        return layout
    }
    
    private func configureView() {
        let vOffset = 30
        let hInset = 16
        
        self.view.addSubview(self.selectedProfileImageView)
        self.selectedProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(vOffset)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.width.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.25)
        }
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.selectedProfileImageView.snp.bottom).offset(vOffset)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(hInset)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.collectionView.registerCellClass(ProfileImageCollectionViewCell.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isScrollEnabled = false
        self.collectionView.backgroundColor = .clear
    }
}

extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return self.viewModel.imageNumberRange.value.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell: ProfileImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else {
            return UICollectionViewCell()
        }
        let imageNumber = self.viewModel.imageNumberRange.value[indexPath.item]
        cell.configureImage(imageNumber: imageNumber)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        self.viewModel.didSelectCell.value = indexPath.item
    }
}
