//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import UIKit

class PlaylistViewController: UIViewController{
    
    //MARK: - vars & outlets
    private let playlist: Playlist
    private var viewModels = [RecommendedTrackCellViewModel]()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        // item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        // group
        
        //vertical group in horezintal group
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)),subitem: item,count: 1)
        // section
        let section = NSCollectionLayoutSection(group: group)
        // to create a header of collection view (top)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
    }))
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        //register
        collectionView.register(RecommendedTracksCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
        collectionView.register(
            PlaylistHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifer)
        // delegation
        collectionView.delegate = self
        collectionView.dataSource = self
        // get data
        DispatchQueue.main.async {
            ApiCaller.shared.getPlaylistDetails(for: self.playlist) { [weak self] result in
                switch result{
                case .success(let model):
                    DispatchQueue.main.async {
                        self?.viewModels = model.tracks.items.compactMap({ item in
                            RecommendedTrackCellViewModel(
                                name: item.track.name,
                                artistName: item.track.artists.first?.name ?? "",
                                artworkURL: URL(string: item.track.album?.images.first?.url ?? ""))
                            
                        })
                        self?.collectionView.reloadData()
                    }
                case.failure(let error):
                    print(error)
                }
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTappeShareButton))
    }
    @objc func didTappeShareButton(){
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else{
            return
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        // for ipad
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier, for: indexPath)as? RecommendedTracksCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.backgroundColor = .red
        cell.config(with: viewModels[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifer, for: indexPath)as? PlaylistHeaderCollectionReusableView else{
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderViewModel(name: playlist.name, ownerName: playlist.owner.display_name, description: playlist.description, artworkURL: URL(string: playlist.images.first?.url ?? ""))
        header.config(with: headerViewModel)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
}
extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate{
    func PlaylistHeaderCollectionReusableViewDidTappedPlayAll(header: PlaylistHeaderCollectionReusableView) {
        // start play playlist all in queue
        print("play all")
    }
}
