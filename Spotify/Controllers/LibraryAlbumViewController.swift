//
//  LibraryAlbumViewController.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 10/08/2022.
//

import UIKit

class LibraryAlbumViewController: UIViewController {
    var albums = [Album]()
    private let noAlbumView = ActionLableView()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero , style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifer)
        tableView.isHidden = true
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Album view controller starting")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoAlbums()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150)
        tableView.frame = view.bounds
    }
    
    //MARK: - private func
    func setUpNoAlbums(){
        noAlbumView.config(with: ActionLableViewModel(title: "you dont have save any Albums yet.", actionTitle: "Browse"))
        noAlbumView.delegate = self
        view.addSubview(noAlbumView)
    }
    func fetchData(){
        ApiCaller.shared.getCurrentUserAlbums{ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success(let albums):
                    self?.albums = albums
                    print(albums)
                    self?.updateUI()
                case.failure(let error):
                    print("error : \(error.localizedDescription)")
                }
            }
        }
    }
    func updateUI(){
        if self.albums.isEmpty {
            // show lable
            noAlbumView.isHidden = false
            tableView.isHidden = true
        }else{
            // show table of albums
            tableView.reloadData()
            noAlbumView.isHidden = true
            tableView.isHidden = false
        }
    }
}
//MARK: - ActionLableViewDelegate , UITableViewDelegate , UITableViewDataSource
extension LibraryAlbumViewController: ActionLableViewDelegate{
    func ActionLableViewDidTapButton(_ actionView: ActionLableView) {
        print("browse selected :)")
        tabBarController?.selectedIndex = 0
    }
}
extension LibraryAlbumViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifer, for: indexPath)as! SearchResultSubtitleTableViewCell
        let album = albums[indexPath.row]
        cell.config(with: SearchResultSubTitleTableViewCellViewModel(title: album.name, subTitle: album.artists.first?.name ?? "", imageUrl: URL(string: album.images.first?.url ?? "")))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        let album = albums[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

