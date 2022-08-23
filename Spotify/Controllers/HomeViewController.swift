//
//  ViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import UIKit

enum BrowseSectionType{
    case newReleases(viewModel: [NewReleasesCellViewModel]) //1
    case featuredPlaylists(viewModel: [FeaturedPlaylistCellViewModel]) //2
    case recommendedTracks(viewModel: [RecommendedTrackCellViewModel]) //3
    
    var title: String {
        switch self {
        case .newReleases:
            return "New Released Albums"
        case .featuredPlaylists:
            return "Featured Playlists"
        case .recommendedTracks:
            return "Recommended"
        }
    }
}
class HomeViewController: UIViewController {
    
    //MARK: - vars & outlets
    
    private var newAlbums: [Album] = []
    private var playlists: [Playlist] = []
    private var tracks: [AudioTrack] = []
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _  in
            return HomeViewController.createSectionLayout(with: sectionIndex)
        }))
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.backgroundColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    private var sections = [BrowseSectionType]()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(settingButtonTapped))
        configCollectionView()
        view.addSubview(spinner)
        fechData()
        addLongTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
    }
    //MARK: - private func
    // get long press geustre
    func addLongTapGesture(){
        let geustre = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(geustre)
    }
    @objc func didLongPress(_ gesture: UILongPressGestureRecognizer){
        guard gesture.state == .began else{
            return
        }
        let touchPoint = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: touchPoint) , indexPath.section == 2 else{
            return
        }
        let model = tracks[indexPath.row]
        let actionSheet = UIAlertController(title: model.name, message: "would you like to add this to a playlist ?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Add to playlist", style: .default, handler: { [weak self] alertAction in
            DispatchQueue.main.async {
                let vc = LibraryPlaylistViewController()
                vc.selectionHandler = {playlist in
                    ApiCaller.shared.addTrackToPlaylist(track: model, playlist: playlist) { success in
                        if success{
                            print("added to playlist \(success)")
                        }
                    }
                }
                vc.title = "Select playlist"
                self?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    @objc func settingButtonTapped(){
        let vc = SettingViewController()
        vc.title = "Setting"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    //fetchData
    private func fechData(){
        let group = DispatchGroup()
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistsResponse?
        var recommendation: RecommendationsResponse?
        
        group.enter()
        group.enter()
        group.enter()
        // new released
        ApiCaller.shared.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result {
            case.failure(let error):
                print(error.localizedDescription)
            case .success(let model):
                newReleases = model
            }
        }
        // featured playlist
        ApiCaller.shared.getFeaturedPlaylist { result in
            defer {
                group.leave()
            }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case.success(let model):
                featuredPlaylist = model
            }
        }
        //get Recommended tracks
        ApiCaller.shared.getRecommendationGenres { result in
            switch result {
            case .failure(let error):
                print(error)
            case.success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement(){
                        seeds.insert(random)
                    }
                }
                ApiCaller.shared.getRecommendation(genres: seeds) { recommendedResult in
                    defer{
                        group.leave()
                    }
                    switch recommendedResult {
                    case .success(let model):
                        recommendation = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        group.notify(queue: .main) {
            guard let newAlbum = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items ,
                  let tracks = recommendation?.tracks else {
                return
            }
            // config the models
            self.configModels(newAlbum: newAlbum, playlist: playlists, tracks: tracks)
        }
        
    }
    private func configModels(newAlbum: [Album] , playlist: [Playlist] , tracks: [AudioTrack]){
        self.newAlbums = newAlbum
        self.playlists = playlist
        self.tracks = tracks
        // compact map it looping of the all elements
        sections.append(.newReleases(viewModel: newAlbum.compactMap({ album in
            return NewReleasesCellViewModel(name: album.name , artworkURL: URL(string: album.images.first?.url ?? ""), numOfTracks: album.total_tracks, artistName: album.artists.first?.name ?? "")
        })))
        sections.append(.featuredPlaylists(viewModel: playlist.compactMap({ playlist in
            return FeaturedPlaylistCellViewModel(name: playlist.name, artwork: URL(string: playlist.images.first?.url ?? ""), creatorName: playlist.owner.display_name)
        })))
        sections.append(.recommendedTracks(viewModel: tracks.compactMap({ audioTrack in
            return RecommendedTrackCellViewModel(name: audioTrack.name, artistName: audioTrack.artists.first?.name ?? "", artworkURL: URL(string: audioTrack.album?.images.first?.url ?? ""))
        })))
        collectionView.reloadData()
    }
    private func configCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier: NewReleasesCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistsCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier)
        collectionView.register(RecommendedTracksCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: TitleHeaderCollectionReusableView.identfier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
}
//MARK: - Extension
extension HomeViewController: UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases( let viewModel):
            return viewModel.count
        case .featuredPlaylists(let viewModel):
            return viewModel.count
        case .recommendedTracks(let viewModel):
            return viewModel.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .newReleases( let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell else{
                return UICollectionViewCell()
                
            }
            cell.config(with: viewModel[indexPath.row])
            return cell
        case .featuredPlaylists(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistsCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.config(with: viewModel[indexPath.row])
            return cell
        case .recommendedTracks(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier, for: indexPath) as? RecommendedTracksCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.config(with: viewModel[indexPath.row])
            return cell
        }
    }
    // did select section item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
        case .newReleases:
            let album = self.newAlbums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case.featuredPlaylists:
            let playlist = self.playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .recommendedTracks:
            let track = self.tracks[indexPath.row]
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identfier, for: indexPath)as? TitleHeaderCollectionReusableView , kind == UICollectionView.elementKindSectionHeader else{
            return UICollectionReusableView()
        }
        let section = sections[indexPath.section]
        let title = section.title
        header.config(title: title)
        return header
        
    }
    //MARK: - create sections layout
    //section & Group & items
    static func  createSectionLayout(with section: Int)-> NSCollectionLayoutSection{
        
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        switch section{
        case 0:
            // item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // group
            
            //vertical group in horezintal group
            let Verticalgroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)),
                                                                 subitem: item,
                                                                 count: 3)
            
            let Horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(390)),
                                                                     subitem: Verticalgroup,
                                                                     count: 1)
            // section
            let section = NSCollectionLayoutSection(group: Horizontalgroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
            //-------------------------
        case 1:
            // item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // group
            
            //vertical group in one horezintal group
            let Verticalgroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)),
                                                                 subitem: item,
                                                                 count: 2)
            let Horezintalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)),
                                                                     subitem: Verticalgroup,
                                                                     count: 1)
            
            // section
            let section = NSCollectionLayoutSection(group: Horezintalgroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
            //-------------------------
        case 2:
            // item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // group
            
            //vertical group in horezintal group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)),
                                                         subitem: item,
                                                         count: 1)
            // section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
            //-------------------------
        default:
            // item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            // group
            
            //vertical group in horezintal group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)),
                                                         subitem: item,
                                                         count: 1)
            // section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
}
