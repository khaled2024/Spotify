//
//  SearchResultViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}
protocol SearchResultViewControllerDelegate: AnyObject {
    func didTappedResult(_ result: SearchResult)
}
class SearchResultViewController: UIViewController {
     weak var delegate: SearchResultViewControllerDelegate?
    private var sections: [SearchSection] = []
    private let tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifer)
        tableview.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifer)
        tableview.isHidden = true
        return tableview
    }()
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    //MARK: - private func
    func update(with results: [SearchResult]){
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        let track = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        let playlists = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        let album = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        self.sections = [
            SearchSection(title: "Songs", results: track),
            SearchSection(title: "Album", results: album),
            SearchSection(title: "Playlist", results: playlists),
            SearchSection(title: "Artists", results: artists)
        ]
        print("sections : \(sections)")
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
        //or
//        if !results.isEmpty {
//            tableView.isHidden = false
//        }else{
//            tableView.isHidden = true
//        }
    }

}
//MARK: - UITableViewDelegate , UITableViewDataSource
extension SearchResultViewController: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let results = sections[indexPath.section].results[indexPath.row]
        switch results{
            // artist
        case .artist(model: let artist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifer, for: indexPath)as? SearchResultDefaultTableViewCell else{
                return UITableViewCell()
            }
            cell.config(with: SearchResultDefaultTableViewCellViewModel(image: URL(string: artist.images?.first?.url ?? ""), title: artist.name))
            return cell
            //album
        case .album(model: let album):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifer, for: indexPath)as? SearchResultSubtitleTableViewCell else{
                return UITableViewCell()
            }
            cell.config(with: SearchResultSubTitleTableViewCellViewModel(title: album.name, subTitle: album.artists.first?.name ?? "-", imageUrl: URL(string: album.images.first?.url ?? "")))
            return cell
            //track
        case .track(model: let track):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifer, for: indexPath)as? SearchResultSubtitleTableViewCell else{
                return UITableViewCell()
            }
            cell.config(with: SearchResultSubTitleTableViewCellViewModel(title: track.name, subTitle: track.artists.first?.name ?? "-", imageUrl: URL(string: track.album?.images.first?.url ?? "")))
            return cell
            // playlist
        case .playlist(model: let playlist):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifer, for: indexPath)as? SearchResultSubtitleTableViewCell else{
                return UITableViewCell()
            }
            cell.config(with: SearchResultSubTitleTableViewCellViewModel(title: playlist.name, subTitle: playlist.owner.display_name, imageUrl: URL(string: playlist.images.first?.url ?? "")))
            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let results = sections[indexPath.section].results[indexPath.row]
        delegate?.didTappedResult(results)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
