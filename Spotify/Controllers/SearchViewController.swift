//
//  ViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.


import UIKit
import SDWebImage
import SafariServices
class SearchViewController: UIViewController{
    private var categories = [Category]()
    private let searchViewController: UISearchController = {
        let result = SearchResultViewController()
        let vc = UISearchController(searchResultsController: result)
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    // collection view
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160)), subitem: item , count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        return NSCollectionLayoutSection(group: group)
    }))
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        searchViewController.searchResultsUpdater = self
        navigationItem.searchController = searchViewController
        view.addSubview(collectionView)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identfier)
        collectionView.delegate = self
        collectionView.dataSource = self
        searchViewController.searchBar.delegate = self
        collectionView.backgroundColor = .systemBackground
        ApiCaller.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .failure(let error):
                    print(error)
                case.success(let categories):
                    self?.categories = categories
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}
//MARK: - UICollectionViewDelegate , UICollectionViewDataSource
extension SearchViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identfier, for: indexPath) as? CategoryCollectionViewCell else{
            return UICollectionViewCell()
        }
        let category = categories[indexPath.row]
        cell.config(with: CategoryCollectionViewCellViewModel(title: category.name, artworkURL: URL(string: category.icons.first?.url ?? "-")))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = CategoryViewController(category: categories[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.modalPresentationStyle = .fullScreen
    }
}
//MARK: - UISearchResultsUpdating , UISearchBarDelegate
extension SearchViewController : UISearchResultsUpdating, UISearchBarDelegate , SearchResultViewControllerDelegate{
    func updateSearchResults(for searchController: UISearchController) {
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultController = searchViewController.searchResultsController as? SearchResultViewController
                ,let query = searchBar.text , !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        resultController.delegate = self
        print(query)
        ApiCaller.shared.search(query: query) { result in
            DispatchQueue.main.async {
                switch result{
                case.success(let results):
                    print(results)
                    resultController.update(with: results)
                    break
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    // the delegate method :-
    func didTappedResult(_ result: SearchResult) {
        switch result{
        case .artist(model: let model):
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else{
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        case .album(model: let model):
            let vc = AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .track(model: let track):
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
            break
        case .playlist(model: let model):
            let vc = PlaylistViewController(playlist: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
